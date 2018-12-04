import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'staff_info.dart';
import 'package:dio/dio.dart';
import 'helper.dart';
import 'Staff.dart';
import 'BaseDomain.dart';
import 'package:event_bus/event_bus.dart';

class Category {
  const Category({ this.name, this.type });
  final String name;
  final int type;

  Category.fromMap(this.name, this.type);
}

EventBus eventBus = EventBus();
const List<Category> allCategories = <Category>[
  Category(name: '全部', type: 0),
  Category(name: '总工', type: 1),
  Category(name: '技术质量部经理', type: 2),
  Category(name: '质量总监', type: 3),
  Category(name: '技术员', type: 4),
  Category(name: '测量员', type: 5),
  Category(name: '资料员', type: 6),
  Category(name: '试验员', type: 7),
  Category(name: '安装员', type: 8),
  Category(name: '技术部管理人员', type: 9),
  Category(name: '质量员', type: 10),
  Category(name: '专业师', type: 11),
];

class CategoryView extends StatefulWidget {
  CategoryView({ Key key, this.category, this.baseDomain, this.source }) : super(key: key);

  Category category;
  final BaseDomain baseDomain;
  final int source;
  List<Staff> staffList = new List();

  @override
  _CategoryViewState createState() => _CategoryViewState();
}

class CategoryUpdateEvent {
  Category category;

  CategoryUpdateEvent(this.category);
}

class _CategoryViewState extends State<CategoryView> {
  ScrollController _scrollController = new ScrollController();
  int _page = 1;
  bool _request = true;

  @override
  void initState() {
    print('intitstate');
    super.initState();

    this.initData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent
          && widget.staffList.length >= 20 && _page > 1) {
        getMore();
      }
    });

    eventBus.on<CategoryUpdateEvent>().listen((event) {
      widget.category = event.category;
      this.initData();
    });
  }

  @override
  void dispose() {
    print('dispose');

    _scrollController.dispose();
    super.dispose();
  }

  void initData() async {
    setState(() {
      _page = 1;
      _request = true;
    });

    api.listStaff(widget.baseDomain.id, _page, widget.source, widget.category.type)
      .then((Response staffResponse) {
      if (staffResponse.data['success']) {
        widget.staffList = Staff.buildList(staffResponse.data['data']);
        print(widget.staffList);
      }
      _request = false;
      _page ++;
      setState(() {});
    });
  }

  void getMore() async {
    setState(() {
      _request = true;
    });

    List<Staff> list;
    Response response = await api.listStaff(widget.baseDomain.id, _page, widget.source, widget.category.type);
    if (response.data['success']) {
      list = Staff.buildList(response.data['data']);
      if (list == null || list.length < 1) {
        _page = -1;
        setState(() {
          _request = false;
        });
        return;
      }
    }
    _page ++;

    if (list != null) {
      setState(() {
        _request = false;
        widget.staffList.addAll(list);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('build,${widget.staffList.length}');
    return _request ? Center(
      child: CircularProgressIndicator(),
    ) : ListView.builder(
      itemCount: widget.staffList.length,
      itemBuilder: (context, index) {
        if (index == widget.staffList.length) {
          return _buildProgressIndicator();
        } else {
          return ListTile(
              leading: new CircleAvatar(child: new Text(String.fromCharCode(widget.staffList[index].name.codeUnitAt(0)))),
              title: new Text(widget.staffList[index].name),
              subtitle: new Text(widget.staffList[index].workType),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ContactsDemo(widget.staffList[index])));
              });
        }
      },
      controller: _scrollController,
    );
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: _request ? 1.0 : 0.0,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

}

// One BackdropPanel is visible at a time. It's stacked on top of the
// the BackdropDemo.
class BackdropPanel extends StatelessWidget {
  const BackdropPanel({
    Key key,
    this.onTap,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
    this.title,
    this.child,
  }) : super(key: key);

  final VoidCallback onTap;
  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;
  final Widget title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      elevation: 2.0,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onVerticalDragUpdate: onVerticalDragUpdate,
            onVerticalDragEnd: onVerticalDragEnd,
            onTap: onTap,
            child: Container(
              height: 48.0,
              padding: const EdgeInsetsDirectional.only(start: 16.0),
              alignment: AlignmentDirectional.centerStart,
              child: DefaultTextStyle(
                style: theme.textTheme.subhead,
                child: Tooltip(
                  message: 'Tap to dismiss',
                  child: title,
                ),
              ),
            ),
          ),
          const Divider(height: 1.0),
          Expanded(child: child),
        ],
      ),
    );
  }
}

// Cross fades between 'Select a Category' and 'Asset Viewer'.
class BackdropTitle extends AnimatedWidget {
  const BackdropTitle({
    Key key,
    Listenable listenable,
  }) : super(key: key, listenable: listenable);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return DefaultTextStyle(
      style: Theme.of(context).primaryTextTheme.title,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      child: Stack(
        children: <Widget>[
          Opacity(
            opacity: CurvedAnimation(
              parent: ReverseAnimation(animation),
              curve: const Interval(0.5, 1.0),
            ).value,
            child: const Text('选择分类'),
          ),
          Opacity(
            opacity: CurvedAnimation(
              parent: animation,
              curve: const Interval(0.5, 1.0),
            ).value,
            child: const Text('Asset Viewer'),
          ),
        ],
      ),
    );
  }
}

// This widget is essentially the backdrop itself.
class BackdropDemo extends StatefulWidget {
  final BaseDomain _baseDomain;
  final int source;

  BackdropDemo(this._baseDomain, this.source);

  @override
  _BackdropDemoState createState() => _BackdropDemoState(allCategories[0]);
}

class _BackdropDemoState extends State<BackdropDemo> with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');
  AnimationController _controller;
  Category _category;

  _BackdropDemoState(this._category);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      value: 1.0,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _changeCategory(Category category) {
    setState(() {
      _category = category;
      _controller.fling(velocity: 2.0);
      eventBus.fire(new CategoryUpdateEvent(category));
    });
  }

  bool get _backdropPanelVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed || status == AnimationStatus.forward;
  }

  void _toggleBackdropPanelVisibility() {
    _controller.fling(velocity: _backdropPanelVisible ? -2.0 : 2.0);
  }

  double get _backdropHeight {
    return 200.0;
  }

  // By design: the panel can only be opened with a swipe. To close the panel
  // the user must either tap its heading or the backdrop's menu icon.

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_controller.isAnimating || _controller.status == AnimationStatus.completed)
      return;

    _controller.value -= details.primaryDelta / (_backdropHeight ?? details.primaryDelta);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating || _controller.status == AnimationStatus.completed)
      return;

    final double flingVelocity = details.velocity.pixelsPerSecond.dy / _backdropHeight;
    if (flingVelocity < 0.0)
      _controller.fling(velocity: math.max(2.0, -flingVelocity));
    else if (flingVelocity > 0.0)
      _controller.fling(velocity: math.min(-2.0, -flingVelocity));
    else
      _controller.fling(velocity: _controller.value < 0.5 ? -2.0 : 2.0);
  }

  // Stacks a BackdropPanel, which displays the selected category, on top
  // of the backdrop. The categories are displayed with ListTiles. Just one
  // can be selected at a time. This is a LayoutWidgetBuild function because
  // we need to know how big the BackdropPanel will be to set up its
  // animation.
  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    const double panelTitleHeight = 48.0;
    final Size panelSize = constraints.biggest;
    final double panelTop = panelSize.height - panelTitleHeight;

    final Animation<RelativeRect> panelAnimation = _controller.drive(
      RelativeRectTween(
        begin: RelativeRect.fromLTRB(
          0.0,
          panelTop - MediaQuery.of(context).padding.bottom,
          0.0,
          panelTop - panelSize.height,
        ),
        end: const RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
      ),
    );

    final ThemeData theme = Theme.of(context);
    final List<Widget> backdropItems = allCategories.map<Widget>((Category category) {
      final bool selected = category == _category;
      return Material(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        color: selected
            ? Colors.white.withOpacity(0.25)
            : Colors.transparent,
        child: ListTile(
          title: Text(category.name),
          selected: selected,
          onTap: () {
            _changeCategory(category);
          },
        ),
      );
    }).toList();

    return Container(
      key: _backdropKey,
      color: theme.primaryColor,
      child: Stack(
        children: <Widget>[
          ListView(
            children: backdropItems,
          ),
          PositionedTransition(
            rect: panelAnimation,
            child: BackdropPanel(
              onTap: _toggleBackdropPanelVisibility,
              onVerticalDragUpdate: _handleDragUpdate,
              onVerticalDragEnd: _handleDragEnd,
              title: Text(_category.name),
              child: CategoryView(
                  category: _category,
                  baseDomain: widget._baseDomain,
                  source: widget.source
              )
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: BackdropTitle(
          listenable: _controller.view,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: _toggleBackdropPanelVisibility,
            icon: AnimatedIcon(
              icon: AnimatedIcons.close_menu,
              semanticLabel: 'close',
              progress: _controller.view,
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: _buildStack,
      ),
    );
  }
}