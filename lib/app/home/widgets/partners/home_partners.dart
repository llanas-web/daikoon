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
                  horizontal: AppSpacing.xxlg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "A l'honneur 🏆",
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
                                style: context.bodyMedium,
                              ),
                              const Text(
                                'Tout voir >',
                                style: TextStyle(
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ].spacerBetween(height: AppSpacing.md),
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
                ],
              ),
            ].spacerBetween(height: AppSpacing.lg),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxlg),
            child: AppDivider(
              color: AppColors.lightGrey,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xxlg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nos Partenaires 🥳',
                      style: context.headlineLarge,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tous nos partenaires à la une',
                                style: context.bodyMedium,
                              ),
                              const Text(
                                'Tout voir >',
                                style: TextStyle(
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ].spacerBetween(height: AppSpacing.md),
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
                ],
              ),
            ].spacerBetween(height: AppSpacing.lg),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxlg),
            child: AppDivider(
              color: AppColors.lightGrey,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xxlg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Offres spéciales 🤩',
                      style: context.headlineLarge,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Les offres du moment',
                                style: context.bodyMedium,
                              ),
                              const Text(
                                'Tout voir >',
                                style: TextStyle(
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ].spacerBetween(height: AppSpacing.md),
                ),
              ),
              horizontalListView(
                [
                  const OfferItem(),
                  const OfferItem(),
                  const OfferItem(),
                ],
              ),
            ].spacerBetween(height: AppSpacing.lg),
          ),
        ].spacerBetween(height: AppSpacing.xxlg),
      ),
    );
  }
}

// Widget for horizontal scrolling list
Widget horizontalListView(List<Widget> items) {
  return SizedBox(
    height: 230,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final lastIndex = items.length - 1;
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(left: AppSpacing.xlg),
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.lg,
                horizontal: AppSpacing.md,
              ),
              child: items[index],
            ),
          );
        } else if (index == lastIndex) {
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.xlg),
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.lg,
                horizontal: AppSpacing.md,
              ),
              child: items[index],
            ),
          );
        } else {
          return Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.lg,
              horizontal: AppSpacing.md,
            ),
            child: items[index],
          );
        }
      },
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
