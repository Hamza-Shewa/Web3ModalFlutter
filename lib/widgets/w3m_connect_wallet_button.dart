import 'package:flutter/material.dart';
import 'package:web3modal_flutter/models/custom_button.dart';

import 'package:web3modal_flutter/services/w3m_service/i_w3m_service.dart';
import 'package:web3modal_flutter/widgets/buttons/base_button.dart';
import 'package:web3modal_flutter/widgets/buttons/connect_button.dart';

class W3MConnectWalletButton extends StatefulWidget {
  const W3MConnectWalletButton({
    super.key,
    required this.service,
    this.title,
    this.button,
    this.size = BaseButtonSize.regular,
    this.state,
    this.onNoChainSelected,
  });

  final IW3MService service;
  final BaseButtonSize size;
  final ConnectButtonState? state;
  final CustomButton? button;
  final String? title;
  final Function? onNoChainSelected;
  @override
  State<W3MConnectWalletButton> createState() => _W3MConnectWalletButtonState();
}

class _W3MConnectWalletButtonState extends State<W3MConnectWalletButton> {
  late ConnectButtonState _state;

  @override
  void initState() {
    super.initState();
    _state = widget.state ?? ConnectButtonState.idle;
    _updateState();
    widget.service.addListener(_updateState);
  }

  @override
  void didUpdateWidget(covariant W3MConnectWalletButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _state = widget.state ?? ConnectButtonState.idle;
    _updateState();
  }

  @override
  void dispose() {
    super.dispose();
    widget.service.removeListener(_updateState);
  }

  @override
  Widget build(BuildContext context) {
    return ConnectButton(
      state: _state,
      size: widget.size,
      onTap: () => _onConnectPressed(context),
      button: widget.button,
      titleOverride: widget.title,
    );
  }

  void _onConnectPressed(BuildContext context) async {
    if (widget.service.selectedChain == null) {
      if (widget.onNoChainSelected != null) {
        widget.onNoChainSelected!();
      }
    }
    if (widget.service.isConnected) {
      widget.service.disconnect();
    } else {
      widget.service.openModal(context);
    }
  }

  void _updateState() {
    final isConnected = widget.service.isConnected;
    if (_state == ConnectButtonState.none && !isConnected) {
      return;
    }
    // Case 0: init error
    if (widget.service.initError != null) {
      return setState(() => _state = ConnectButtonState.error);
    }
    // Case 1: Is connected
    else if (widget.service.isConnected) {
      return setState(() => _state = ConnectButtonState.connected);
    }
    // Case 1.5: No required namespaces
    else if (widget.service.requiredNamespaces.isEmpty) {
      return setState(() => _state = ConnectButtonState.disabled);
    }
    // Case 2: Is not open and is not connected
    else if (!widget.service.isOpen && !widget.service.isConnected) {
      return setState(() => _state = ConnectButtonState.idle);
    }
    // Case 3: Is open and is not connected
    else if (widget.service.isOpen && !widget.service.isConnected) {
      return setState(() => _state = ConnectButtonState.connecting);
    }
  }
}
