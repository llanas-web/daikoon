import 'package:powersync/powersync.dart';

/// The schema of the database.
const schema = Schema([
  Table('bets', [
    Column.text('created_at'),
    Column.text('choice_id'),
    Column.text('user_id'),
    Column.integer('amount'),
  ]),
  Table('challenges', [
    Column.text('created_at'),
    Column.text('title'),
    Column.text('question'),
    Column.text('starting'),
    Column.text('ending'),
    Column.text('creator_id'),
    Column.text('limit_date'),
    Column.integer('has_bet'),
    Column.integer('min_bet'),
    Column.integer('max_bet'),
    Column.integer('amount'),
  ]),
  Table('choices', [
    Column.text('created_at'),
    Column.text('challenge_id'),
    Column.text('value'),
    Column.integer('is_correct'),
  ]),
  Table('participants', [
    Column.text('created_at'),
    Column.text('user_id'),
    Column.text('challenge_id'),
    Column.text('status'),
  ]),
  Table('users', [
    Column.text('created_at'),
    Column.text('email'),
    Column.text('username'),
    Column.text('avatar_url'),
    Column.text('push_token'),
    Column.text('full_name'),
  ]),
  Table('friendships', [
    Column.text('sender_id'),
    Column.text('created_at'),
    Column.text('receiver_id'),
  ]),
  Table('notifications', [
    Column.text('created_at'),
    Column.text('user_id'),
    Column.text('title'),
    Column.text('body'),
    Column.text('status'),
    Column.text('type'),
    Column.text('metadatas'),
  ]),
  Table('wallets', [
    Column.text('created_at'),
    Column.text('user_id'),
    Column.integer('amount'),
  ]),
  Table('transactions', [
    Column.text('created_at'),
    Column.text('sender_id'),
    Column.text('receiver_id'),
    Column.integer('amount'),
    Column.text('origin_id'),
    Column.text('status'),
  ]),
]);
