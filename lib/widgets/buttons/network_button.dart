import 'package:flutter/material.dart';

import 'package:web3modal_flutter/constants/string_constants.dart';
import 'package:web3modal_flutter/models/custom_button.dart';
import 'package:web3modal_flutter/models/w3m_chain_info.dart';
import 'package:web3modal_flutter/services/explorer_service/explorer_service_singleton.dart';
import 'package:web3modal_flutter/theme/w3m_theme.dart';
import 'package:web3modal_flutter/utils/asset_util.dart';
import 'package:web3modal_flutter/widgets/buttons/base_button.dart';
import 'package:web3modal_flutter/widgets/icons/rounded_icon.dart';

class NetworkButton extends StatelessWidget {
  const NetworkButton({
    super.key,
    this.size = BaseButtonSize.regular,
    this.button,
    this.chainInfo,
    this.onTap,
  });
  final W3MChainInfo? chainInfo;
  final BaseButtonSize size;
  final VoidCallback? onTap;
  final CustomButton? button;
  String _getImageUrl(W3MChainInfo chainInfo) {
    if (chainInfo.chainIcon != null && chainInfo.chainIcon!.contains('http')) {
      return chainInfo.chainIcon!;
    }
    final chainImageId = AssetUtil.getChainIconId(chainInfo.chainId);
    return explorerService.instance!.getAssetImageUrl(chainImageId);
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = Web3ModalTheme.colorsOf(context);
    final imageUrl = chainInfo != null ? _getImageUrl(chainInfo!) : null;
    final radiuses = Web3ModalTheme.radiusesOf(context);
    final borderRadius = radiuses.isSquare() ? 0.0 : size.height / 2;
    if (button != null) {
      return MaterialButton(
        onPressed: onTap,
        elevation: 0,
        height: button!.height,
        minWidth: button!.width,
        highlightColor:
            button!.highlightColor ?? Theme.of(context).colorScheme.secondary,
        splashColor:
            button!.splashColor ?? Theme.of(context).colorScheme.secondary,
        color:
            button!.color ?? Theme.of(context).primaryColorDark.withOpacity(.6),
        shape: button!.shape ??
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RoundedIcon(
              assetPath: 'assets/icons/network.svg',
              imageUrl: imageUrl,
              size: size.height - 12.0,
              assetColor: themeColors.inverse100,
              padding: 6.0,
            ),
            SizedBox(width: 8),
            button!.child(
              chainInfo?.chainName ??
                  (size == BaseButtonSize.small
                      ? StringConstants.selectNetworkShort
                      : StringConstants.selectNetwork),
            ),
          ],
        ),
      );
    } else {
      return BaseButton(
        size: size,
        onTap: onTap,
        buttonStyle: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(MaterialState.disabled)) {
                return themeColors.grayGlass005;
              }
              return themeColors.grayGlass010;
            },
          ),
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(MaterialState.disabled)) {
                return themeColors.grayGlass015;
              }
              return themeColors.foreground100;
            },
          ),
          shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
            (states) {
              return RoundedRectangleBorder(
                side: states.contains(MaterialState.disabled)
                    ? BorderSide(color: themeColors.grayGlass005, width: 1.0)
                    : BorderSide(color: themeColors.grayGlass010, width: 1.0),
                borderRadius: BorderRadius.circular(borderRadius),
              );
            },
          ),
        ),
        icon: RoundedIcon(
          assetPath: 'assets/icons/network.svg',
          imageUrl: imageUrl,
          size: size.height - 12.0,
          assetColor: themeColors.inverse100,
          padding: 6.0,
        ),
        child: Text(
          chainInfo?.chainName ??
              (size == BaseButtonSize.small
                  ? StringConstants.selectNetworkShort
                  : StringConstants.selectNetwork),
        ),
      );
    }
  }
}
