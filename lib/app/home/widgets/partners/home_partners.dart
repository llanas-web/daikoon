import 'package:app_ui/app_ui.dart';
import 'package:daikoon/app/home/home.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:daikoon_blocks_ui/daikoon_blocks_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:shared/shared.dart';

class HomePartners extends StatelessWidget {
  const HomePartners({super.key});

  static final _partnerItem = PartnersItem(
    title: "L'Orangerie",
    subtitle: 'Jus pressés 🍊',
    description: "A récupérer aujourd'hui 07:00 - 19:00",
    stars: 4.5,
    distance: 4.6,
    price: 1.99,
    image: Assets.images.orangerie,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withValues(alpha: 0),
            AppColors.primary.withValues(alpha: 0.5),
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxlg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PartnersListItem(
            title: context.l10n.homePartnersHonorTitle,
            subtitle: context.l10n.homePartnersHonorSubtitle,
            children: List.generate(3, (index) => _partnerItem),
          ),
          PartnersListItem(
            title: context.l10n.homePartnersListTitle,
            subtitle: context.l10n.homePartnersListSubtitle,
            children: List.generate(3, (index) => _partnerItem),
          ),
          PartnersListItem(
            title: context.l10n.homeOffersTitle,
            subtitle: context.l10n.homeOffersSubtitle,
            children: List.generate(3, (index) => const OfferItem()),
          ) as Widget,
        ]
            .insertBetween(
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxlg),
                child: AppDivider(color: AppColors.lightGrey),
              ),
            )
            .spacerBetween(height: AppSpacing.xxlg),
      ),
    );
  }
}

class PartnersListItem extends StatelessWidget {
  const PartnersListItem({
    required this.title,
    required this.subtitle,
    required this.children,
    super.key,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxlg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: context.headlineLarge),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(subtitle, style: context.bodyMedium),
                        Text(
                          context.l10n.homePartnersSeeAll,
                          style: const TextStyle(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ].spacerBetween(height: AppSpacing.md),
          ),
        ),
        DaikoonHorizontalScroll(
          height: 230,
          horizontalPadding: AppSpacing.xxlg,
          children: [...children],
        ),
      ].spacerBetween(height: AppSpacing.lg),
    );
  }
}
