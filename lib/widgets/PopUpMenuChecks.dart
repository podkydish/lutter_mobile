import 'package:flutter/material.dart';

const double _kMenuHorizontalPadding = 16.0;

class PopUpMenuChecks<T> extends PopupMenuEntry<T> {
  const PopUpMenuChecks({
    super.key,
    this.value,
    this.onTap,
    this.enabled = true,
    this.height = kMinInteractiveDimension,
    this.padding,
    this.textStyle,
    this.labelTextStyle,
    this.mouseCursor,
    required this.child,
  });

  final T? value;

  final VoidCallback? onTap;

  final bool enabled;

  @override
  final double height;

  final EdgeInsets? padding;

  final TextStyle? textStyle;

  final MaterialStateProperty<TextStyle?>? labelTextStyle;

  final MouseCursor? mouseCursor;

  final Widget? child;

  @override
  bool represents(T? value) => value == this.value;

  @override
  PopupMenuItemChecksState<T, PopUpMenuChecks<T>> createState() =>
      PopupMenuItemChecksState<T, PopUpMenuChecks<T>>();
}

class PopupMenuItemChecksState<T, W extends PopUpMenuChecks<T>>
    extends State<W> {
  @protected
  Widget? buildChild() => widget.child;

  @protected
  void handleTap() {}

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final PopupMenuThemeData defaults = theme.useMaterial3
        ? _PopupMenuDefaultsM3(context)
        : _PopupMenuDefaultsM2(context);
    final Set<MaterialState> states = <MaterialState>{
      if (!widget.enabled) MaterialState.disabled,
    };

    TextStyle style = theme.useMaterial3
        ? (widget.labelTextStyle?.resolve(states) ??
            popupMenuTheme.labelTextStyle?.resolve(states)! ??
            defaults.labelTextStyle!.resolve(states)!)
        : (widget.textStyle ?? popupMenuTheme.textStyle ?? defaults.textStyle!);

    if (!widget.enabled && !theme.useMaterial3) {
      style = style.copyWith(color: theme.disabledColor);
    }

    Widget item = AnimatedDefaultTextStyle(
      style: style,
      duration: kThemeChangeDuration,
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        constraints: BoxConstraints(minHeight: widget.height),
        padding: widget.padding ??
            const EdgeInsets.symmetric(horizontal: _kMenuHorizontalPadding),
        child: buildChild(),
      ),
    );

    if (!widget.enabled) {
      final bool isDark = theme.brightness == Brightness.dark;
      item = IconTheme.merge(
        data: IconThemeData(opacity: isDark ? 0.5 : 0.38),
        child: item,
      );
    }

    return MergeSemantics(
      child: Semantics(
        enabled: widget.enabled,
        button: true,
        child: InkWell(
          onTap: widget.enabled ? handleTap : null,
          canRequestFocus: widget.enabled,
          mouseCursor: _EffectiveMouseCursor(
              widget.mouseCursor, popupMenuTheme.mouseCursor),
          child: item,
        ),
      ),
    );
  }
}

class _PopupMenuDefaultsM3 extends PopupMenuThemeData {
  _PopupMenuDefaultsM3(this.context) : super(elevation: 3.0);

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;
  late final TextTheme _textTheme = _theme.textTheme;

  @override
  MaterialStateProperty<TextStyle?>? get labelTextStyle {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      final TextStyle style = _textTheme.labelLarge!;
      if (states.contains(MaterialState.disabled)) {
        return style.apply(color: _colors.onSurface.withOpacity(0.38));
      }
      return style.apply(color: _colors.onSurface);
    });
  }

  @override
  Color? get color => _colors.surface;

  @override
  Color? get shadowColor => _colors.shadow;

  @override
  Color? get surfaceTintColor => _colors.surfaceTint;

  @override
  ShapeBorder? get shape => const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)));
}

class _PopupMenuDefaultsM2 extends PopupMenuThemeData {
  _PopupMenuDefaultsM2(this.context) : super(elevation: 8.0);

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final TextTheme _textTheme = _theme.textTheme;

  @override
  TextStyle? get textStyle => _textTheme.subtitle1;
}

class _EffectiveMouseCursor extends MaterialStateMouseCursor {
  const _EffectiveMouseCursor(this.widgetCursor, this.themeCursor);

  final MouseCursor? widgetCursor;
  final MaterialStateProperty<MouseCursor?>? themeCursor;

  @override
  MouseCursor resolve(Set<MaterialState> states) {
    return MaterialStateProperty.resolveAs<MouseCursor?>(
            widgetCursor, states) ??
        themeCursor?.resolve(states) ??
        MaterialStateMouseCursor.clickable.resolve(states);
  }

  @override
  String get debugDescription => 'MaterialStateMouseCursor(PopupMenuItemState)';
}
