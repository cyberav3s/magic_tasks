// ignore_for_file: discarded_futures

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:magic_tasks/core/constants/app_colors.dart';
import 'package:magic_tasks/core/constants/app_spacing.dart';
import 'package:magic_tasks/core/extensions/build_context_extension.dart';
import 'package:magic_tasks/core/extensions/text_style_extension.dart';
import 'package:magic_tasks/core/widgets/tappable.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pausable_timer/pausable_timer.dart';

class SnackbarMessage {
  const SnackbarMessage({
    this.title = '',
    this.description,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.timeout = const Duration(milliseconds: 3500),
    this.onTap,
    this.isError = false,
    this.shakeCount = 3,
    this.shakeOffset = 10,
    this.undismissable = false,
    this.dismissWhen,
    this.isLoading = false,
    this.backgroundColor,
  });

  const SnackbarMessage.success({
    String title = 'Successfully!',
    String? description,
    Duration timeout = const Duration(milliseconds: 3500),
  }) : this(
         title: title,
         description: description,
         icon: Symbols.done,
         backgroundColor: AppColors.success,
         timeout: timeout,
       );

  const SnackbarMessage.loading({
    String title = 'Loading...',
    Duration timeout = const Duration(milliseconds: 3500),
  }) : this(title: title, isLoading: true, timeout: timeout);

  const SnackbarMessage.error({
    String title = '',
    String? description,
    IconData? icon,
    Duration timeout = const Duration(milliseconds: 3500),
  }) : this(
         title: title,
         description: description,
         icon: icon ?? Symbols.cancel_rounded,
         backgroundColor: AppColors.error,
         isError: true,
         timeout: timeout,
       );

  final String title;
  final String? description;
  final IconData? icon;
  final double? iconSize;
  final Color? iconColor;
  final Duration timeout;
  final VoidCallback? onTap;
  final bool isError;
  final int shakeCount;
  final int shakeOffset;
  final bool undismissable;
  final FutureOr<bool>? dismissWhen;
  final bool isLoading;
  final Color? backgroundColor;
}

class AppSnackbar extends StatefulWidget {
  const AppSnackbar({super.key});

  @override
  State<AppSnackbar> createState() => AppSnackbarState();
}

class AppSnackbarState extends State<AppSnackbar>
    with TickerProviderStateMixin {
  PausableTimer? currentTimeout;

  late AnimationController _animationControllerY;
  late AnimationController _animationControllerX;
  late AnimationController _animationControllerErrorShake;

  double totalMovedNegative = 0;
  List<SnackbarMessage> currentQueue = [];
  SnackbarMessage? currentMessage;

  void post(
    SnackbarMessage message, {
    required bool clearIfQueue,
    required bool undismissable,
  }) {
    if (clearIfQueue && currentQueue.isNotEmpty) {
      currentQueue.add(message);
      animateOut();
      return;
    }
    currentQueue.add(message);
    if (currentQueue.length <= 1) {
      animateIn(message, undismissable: undismissable);
    }
  }

  Future<void> animateIn(SnackbarMessage message, {bool undismissable = false}) async {
    setState(() {
      currentMessage = currentQueue[0];
    });
    unawaited(_animationControllerX.animateTo(0.5, duration: Duration.zero));
    await _animationControllerY.animateTo(
      0.5,
      curve: const ElasticOutCurve(0.8),
      duration: Duration(
        milliseconds: ((_animationControllerY.value - 0.5).abs() * 800 + 900)
            .toInt(),
      ),
    );
    if (message.isError) {
      shake();
    }
    currentTimeout = PausableTimer(message.timeout, animateOut);
    currentTimeout!.start();
  }

  void animateOut() {
    currentTimeout?.cancel();
    _animationControllerY.animateTo(
      0,
      curve: Curves.elasticOut,
      duration: Duration(
        milliseconds: ((_animationControllerY.value - 0.5).abs() * 800 + 2000)
            .toInt(),
      ),
    );

    if (currentQueue.isNotEmpty) {
      currentQueue.removeAt(0);
    }
    if (currentQueue.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 150), () {
        animateIn(currentQueue[0]);
      });
    }
  }

  void closeAll() {
    currentQueue.clear();
    currentTimeout?.cancel();
    _animationControllerY.animateTo(
      0,
      curve: Curves.elasticOut,
      duration: Duration(
        milliseconds: ((_animationControllerY.value - 0.5).abs() * 800 + 2000)
            .toInt(),
      ),
    );
  }

  void shake() => _animationControllerErrorShake.forward();

  @override
  void initState() {
    super.initState();

    _animationControllerY = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationControllerX = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationControllerErrorShake = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addStatusListener(_updateStatus);
  }

  void _updateStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _animationControllerErrorShake.reset();
    }
  }

  void _onPointerMove(PointerMoveEvent ptr) {
    if (ptr.delta.dy <= 0) {
      totalMovedNegative += ptr.delta.dy;
    }
    if (_animationControllerY.value <= 0.5) {
      _animationControllerY.value += ptr.delta.dy / 400;
    } else {
      _animationControllerY.value +=
          ptr.delta.dy / (2000 * _animationControllerY.value * 8);
    }
    _animationControllerX.value +=
        ptr.delta.dx / (1000 + (_animationControllerX.value - 0.5).abs() * 100);

    currentTimeout!.pause();
  }

  void _onPointerUp(PointerUpEvent event) {
    if (totalMovedNegative <= -200) {
      animateOut();
    } else if (_animationControllerY.value <= 0.4) {
      animateOut();
    } else {
      _animationControllerY.animateTo(
        0.5,
        curve: Curves.elasticOut,
        duration: Duration(
          milliseconds: ((_animationControllerY.value - 0.5).abs() * 800 + 700)
              .toInt(),
        ),
      );

      currentTimeout!.start();
    }

    _animationControllerX.animateTo(
      0.5,
      curve: Curves.elasticOut,
      duration: Duration(
        milliseconds: ((_animationControllerX.value - 0.5).abs() * 800 + 700)
            .toInt(),
      ),
    );
    totalMovedNegative = 0;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationControllerX,
      builder: (context, child) {
        return child!;
      },
      child: AnimatedBuilder(
        animation: _animationControllerY,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              (_animationControllerX.value - 0.5) * 100,
              (_animationControllerY.value - 0.5) * 400 +
                  context.viewPadding.top +
                  10,
            ),
            child: child,
          );
        },
        child: Listener(
          onPointerMove: _onPointerMove,
          onPointerUp: _onPointerUp,
          child: Center(
            child: Align(
              alignment: Alignment.topCenter,
              child: AnimatedBuilder(
                animation: _animationControllerErrorShake,
                builder: (context, child) {
                  final sineValue = sin(
                    currentMessage?.shakeCount ??
                        3 * 2 * pi * _animationControllerErrorShake.value,
                  );
                  final shakeOffset = currentMessage?.shakeOffset ?? 10;
                  return Transform.translate(
                    offset: Offset(sineValue * shakeOffset, 0),
                    child: child,
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.dark.withAlpha(10),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Tappable.faded(
                    onTap: () {
                      if (currentMessage?.onTap != null) {
                        currentMessage?.onTap!.call();
                      }
                      animateOut();
                    },
                    borderRadius: BorderRadius.circular(13),
                    backgroundColor:
                        currentMessage?.backgroundColor ?? Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (currentMessage?.icon == null)
                                const SizedBox.shrink()
                              else
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: AppSpacing.md - AppSpacing.xxs,
                                  ),
                                  child: Icon(
                                    currentMessage?.icon,
                                    size: currentMessage?.iconSize ?? 24,
                                    color: currentMessage?.iconColor,
                                  ),
                                ),
                              if (currentMessage?.isLoading == null)
                                const SizedBox.shrink()
                              else if (currentMessage?.isLoading != null &&
                                  currentMessage!.isLoading == true)
                                const Padding(
                                  padding: EdgeInsets.only(
                                    right: AppSpacing.md - AppSpacing.xxs,
                                  ),
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment:
                                      currentMessage?.icon == null
                                      ? CrossAxisAlignment.center
                                      : CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      currentMessage?.icon == null
                                      ? MainAxisAlignment.center
                                      : MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentMessage?.title ?? '',
                                      style: context.titleSmall,
                                      textAlign: currentMessage?.icon == null
                                          ? TextAlign.center
                                          : TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    ),
                                    if (currentMessage?.description != null)
                                      Text(
                                        currentMessage?.description ?? '',
                                        style: context.bodySmall,
                                        textAlign: currentMessage?.icon == null
                                            ? TextAlign.center
                                            : TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
