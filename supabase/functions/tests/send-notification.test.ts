// Import required libraries and modules
import { assertEquals } from "jsr:@std/assert";
import { createClient, SupabaseClient } from "jsr:@supabase/supabase-js@2";

// Will load the .env file to Deno.env
import "https://deno.land/x/dotenv@v3.2.2/load.ts";

// Set up the configuration for the Supabase client
const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
const supabaseKey = Deno.env.get("SUPABASE_ANON_KEY") ?? "";
const options = {
  auth: {
    autoRefreshToken: false,
    persistSession: false,
    detectSessionInUrl: false,
  },
};

console.log("Supabase URL: " + supabaseUrl);
console.log("Supabase Key: " + supabaseKey);

// Test the creation and functionality of the Supabase client
const testNotification = async () => {
  const client: SupabaseClient = createClient(
    supabaseUrl,
    supabaseKey,
    options,
  );

  // Verify if the Supabase URL and key are provided
  if (!supabaseUrl) throw new Error("supabaseUrl is required.");
  if (!supabaseKey) throw new Error("supabaseKey is required.");

  // Test a simple query to the database
  const { data: newNotification, error: table_error } = await client
    .from("notifications")
    .insert({
      title: "Hello, World!",
      user_id: "5de4a51d-8ab6-4a53-926e-a0ae98005d8c",
      body: "This is a test notification.",
    })
    .select().single();
  if (table_error) {
    throw new Error("Invalid Supabase client: " + table_error.message);
  }
  assertEquals(newNotification.status, "pending");
  // const { data: func_data, error: func_error } = await client.functions.invoke(
  //   "send-notification",
  //   {
  //     body: {
  //       record: {
  //         id: newNotification.id,
  //         title: "title",
  //         body: "body",
  //         user_id: "5de4a51d-8ab6-4a53-926e-a0ae98005d8c",
  //       },
  //     },
  //   },
  // );

  // // Check for errors from the function invocation
  // if (func_error) {
  //   throw new Error("Invalid response: " + func_error.message);
  // }

  // // Log the response from the function
  // console.log(JSON.stringify(func_data, null, 2));

  // // Assert that the function returned the expected result
  // assertEquals(func_data, "");

  await new Promise((resolve) => setTimeout(resolve, 5000));

  const { data: updatedNotif } = await client.from("notifications").select().eq(
    "id",
    newNotification.id,
  ).single();

  console.log(updatedNotif);

  assertEquals<string>(updatedNotif.status, "sent");

  client.from("notifications").delete().eq("id", newNotification.id).single();
};

// Register and run the tests
Deno.test("Send notification test", testNotification);
