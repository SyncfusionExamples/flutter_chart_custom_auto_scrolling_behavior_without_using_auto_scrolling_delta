import 'package:flutter/material.dart';

void main() {
  runApp(const ExpenseAnalysis());
}

class ExpenseAnalysis extends StatefulWidget {
  const ExpenseAnalysis({super.key});

  @override
  State<ExpenseAnalysis> createState() => _ExpenseAnalysisState();
}

class _ExpenseAnalysisState extends State<ExpenseAnalysis> {
  int _selectedIndex = 0;
  final List<GlobalKey> _iconPositioned =
      List.generate(8, (index) => GlobalKey());

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: Row(
        children: [
          CustomSideBar(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
            iconPositioned: _iconPositioned,
          ),
          Expanded(
              child: Scaffold(
            body: Center(
                child: Text(
              "PAGE $_selectedIndex",
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            )),
          ))
        ],
      ),
    );
  }
}

class CustomSideBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  final List<GlobalKey> iconPositioned;

  const CustomSideBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.iconPositioned,
  });

  @override
  State<CustomSideBar> createState() => _CustomSideBarState();
}

class _CustomSideBarState extends State<CustomSideBar>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final GlobalKey _moreOptionPositioning = GlobalKey();
  double _topPosition = 0;
  OverlayEntry? _overlayEntry;
  bool _isPopupVisible = false;
  List<int> _overflowIndexes = [];
  late AnimationController _animationController;
  int? _popupSelectedIndex;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (_isPopupVisible) {
      _hidePopup();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTopPosition();
      _calculateOverflowIndexes();
    });
  }

  @override
  void didUpdateWidget(CustomSideBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTopPosition();
      _calculateOverflowIndexes();
    });
  }

  void _updateTopPosition() {
    setState(() {
      _topPosition = _calculateTopPosition(context, widget.selectedIndex);
    });
  }

  void _calculateOverflowIndexes() {
    setState(() {
      _overflowIndexes = _calculateOverflowedIcons();
    });
  }

  void _showPopup() {
    if (_isPopupVisible) return;

    final overlay = Overlay.of(context);
    _overlayEntry = _createOverlayEntry();
    overlay.insert(_overlayEntry!);
    setState(() {
      _isPopupVisible = true;
    });
    _animationController.forward();
  }

  void _hidePopup() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      setState(() {
        _isPopupVisible = false;
        _popupSelectedIndex = null;
      });
    }
    _animationController.reverse();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox =
        _moreOptionPositioning.currentContext?.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _hidePopup,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned(
              left: offset.dx + 65,
              top: offset.dy - (_overflowIndexes.length * 48),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 64,
                  color: const Color(0xff6750A4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _overflowIndexes
                        .map((index) =>
                            _buildPopupIcon(_getIconData(index), index))
                        .toList(),
                  ),
                ),
              ),
            ),
            if (_popupSelectedIndex != null && !_isAnimating)
              Positioned(
                left: offset.dx + 65,
                top: _calculatePopupTopPosition(_popupSelectedIndex!),
                child: _buildAnimatedIcon(),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double iconHeight = 56;
        int availableHeight = (constraints.maxHeight - 280).toInt();
        double topIconsHeight = iconHeight * 4;
        int maxBottomIconsInView =
            ((availableHeight - topIconsHeight) / iconHeight).floor();
        bool showMoreIcon = maxBottomIconsInView < 4;

        List<Widget> primaryIconsTop = _buildPrimaryIconsTop();
        List<Widget> primaryIconsBottom =
            _buildPrimaryIconsBottom(maxBottomIconsInView);

        return Stack(
          children: [
            Container(
              width: 64,
              color: const Color(0xff6750A4),
              child: Stack(
                children: [
                  if (!_isPopupVisible || _isAnimating)
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      top: _topPosition,
                      left: 8,
                      child: _buildAnimatedIcon(),
                    ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          children: primaryIconsTop,
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          children: primaryIconsBottom,
                        ),
                      ),
                      if (showMoreIcon) _buildMoreIconButton(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildPrimaryIconsTop() {
    return List<Widget>.generate(4, (i) => _buildIcon(_getIconData(i), i));
  }

  List<Widget> _buildPrimaryIconsBottom(int maxBottomIconsInView) {
    List<Widget> primaryIconsBottom = [];
    _overflowIndexes.clear();
    for (int i = 4; i < 8; i++) {
      if (i - 4 < maxBottomIconsInView) {
        primaryIconsBottom.add(_buildIcon(_getIconData(i), i));
      } else {
        _overflowIndexes.add(i);
      }
    }
    return primaryIconsBottom;
  }

  IconButton _buildMoreIconButton() {
    return IconButton(
      key: _moreOptionPositioning,
      icon: const Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: Icon(
          Icons.more_horiz,
          color: Colors.white,
        ),
      ),
      onPressed: () {
        if (_isPopupVisible) {
          _hidePopup();
        } else {
          _showPopup();
        }
      },
      tooltip: 'Show menu',
    );
  }

  IconData _getIconData(int index) {
    switch (index) {
      case 0:
        return Icons.home_outlined;
      case 1:
        return Icons.receipt_long_outlined;
      case 2:
        return Icons.attach_money_outlined;
      case 3:
        return Icons.savings_outlined;
      case 4:
        return Icons.nightlight_outlined;
      case 5:
        return Icons.person_outline_rounded;
      case 6:
        return Icons.settings_outlined;
      case 7:
        return Icons.help_outline;
      default:
        return Icons.error;
    }
  }

  Widget _buildIcon(IconData iconData, int index) {
    return GestureDetector(
      key: widget.iconPositioned[index],
      onTap: () {
        setState(() {
          _isAnimating = true;
        });
        widget.onItemTapped(index);
        _hidePopup();
      },
      child: SizedBox(
        width: 48,
        height: 48,
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Icon(
            iconData,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildPopupIcon(IconData iconData, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _popupSelectedIndex = index;
          widget.onItemTapped(index);
          _isAnimating = true;
        });
        _animationController.forward().whenComplete(() {
          _hidePopup();
        });
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _animationController.value,
            child: SizedBox(
              width: 48,
              height: 48,
              child: Icon(
                iconData,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  double _calculateTopPosition(BuildContext context, int selectedIndex) {
    RenderBox? renderBox = widget.iconPositioned[selectedIndex].currentContext
        ?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      return renderBox.localToGlobal(Offset.zero).dy -
          8 -
          MediaQuery.of(context).padding.top;
    }
    return -MediaQuery.of(context).size.height * 0.5;
  }

  List<int> _calculateOverflowedIcons() {
    double iconHeight = 56;
    double availableHeight = MediaQuery.of(context).size.height - 320;
    double topIconsHeight = iconHeight * 4;
    int maxBottomIconsInView =
        ((availableHeight - topIconsHeight) / iconHeight).floor();
    List<int> overflowIndexes = [];

    for (int i = 4; i < 8; i++) {
      if (i - 4 >= maxBottomIconsInView) {
        overflowIndexes.add(i);
      }
    }
    return overflowIndexes;
  }

  double _calculatePopupTopPosition(int index) {
    double iconHeight = 56;
    int position = index - 4;
    return position * iconHeight;
  }

  Widget _buildAnimatedIcon() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xff21005D),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
