import 'package:app_ui/app_ui.dart';
import 'package:daikoon/app/home/home.dart';
import 'package:flutter/widgets.dart';
import 'package:shared/shared.dart';

class HomePartners extends StatelessWidget {
  const HomePartners({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxlg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xlg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'A l`honneur',
                      style: context.headlineLarge,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Les points de vents',
                                style: context.headlineSmall,
                              ),
                              const Text(
                                'Tout voir',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              horizontalListView(
                [
                  PartnersItem(
                    title: "L'Orangerie",
                    subtitle: 'Jus pressés 🍊',
                    description: "A récupérer aujourd'hui 07:00 - 19:00",
                    stars: 4.5,
                    distance: 4.6,
                    price: 1.99,
                    image: Assets.images.orangerie,
                  ),
                  PartnersItem(
                    title: "L'Orangerie",
                    subtitle: 'Jus pressés 🍊',
                    description: "A récupérer aujourd'hui 07:00 - 19:00",
                    stars: 4.5,
                    distance: 4.6,
                    price: 1.99,
                    image: Assets.images.orangerie,
                  ),
                  PartnersItem(
                    title: "L'Orangerie",
                    subtitle: 'Jus pressés 🍊',
                    description: "A récupérer aujourd'hui 07:00 - 19:00",
                    stars: 4.5,
                    distance: 4.6,
                    price: 1.99,
                    image: Assets.images.orangerie,
                  ),
                ].spacerBetween(width: AppSpacing.xlg),
              ),
            ].spacerBetween(height: AppSpacing.md),
          ),
          Column(
            children: [
              Text(
                'A l`honneur',
                style: context.headlineLarge,
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Les points de vents',
                          style: context.headlineSmall,
                        ),
                        const Text(
                          'Tout voir',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              horizontalListView(
                [
                  PartnersItem(
                    title: "L'Orangerie",
                    subtitle: 'Jus pressés 🍊',
                    description: "A récupérer aujourd'hui 07:00 - 19:00",
                    stars: 4.5,
                    distance: 4.6,
                    price: 1.99,
                    image: Assets.images.orangerie,
                  ),
                  PartnersItem(
                    title: "L'Orangerie",
                    subtitle: 'Jus pressés 🍊',
                    description: "A récupérer aujourd'hui 07:00 - 19:00",
                    stars: 4.5,
                    distance: 4.6,
                    price: 1.99,
                    image: Assets.images.orangerie,
                  ),
                  PartnersItem(
                    title: "L'Orangerie",
                    subtitle: 'Jus pressés 🍊',
                    description: "A récupérer aujourd'hui 07:00 - 19:00",
                    stars: 4.5,
                    distance: 4.6,
                    price: 1.99,
                    image: Assets.images.orangerie,
                  ),
                ].spacerBetween(width: AppSpacing.xlg),
              ),
            ].spacerBetween(height: AppSpacing.md),
          ),
        ]
            .spacerBetween(height: AppSpacing.xlg)
            .insertBetween(const AppDivider(color: AppColors.primary)),
      ),
    );
  }
}

// Widget for horizontal scrolling list
Widget horizontalListView(List<Widget> items) {
  return SizedBox(
    height: 150, // Adjust height accordingly
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(left: AppSpacing.md),
        child: items[index],
      ),
    ),
  );
}

// // Discount card widget
// Widget discountItem(String discount, String store, String details) {
//   return Container(
//     width: 160,
//     decoration: BoxDecoration(
//       color: Colors.pink,
//       borderRadius: BorderRadius.circular(12),
//     ),
//     padding: EdgeInsets.all(12),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Text(discount, style: TextStyle(fontSize: 22, color: Colors.white)),
//         Text(store, style: TextStyle(fontSize: 18, color: Colors.white)),
//         Text(details, style: TextStyle(fontSize: 14, color: Colors.white)),
//       ],
//     ),
//   );
// }
