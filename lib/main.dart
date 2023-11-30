import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animation',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: AnimationScreen(),
    );
  }
}

class AnimationScreen extends StatefulWidget {
  @override
  _AnimationScreenState createState() => _AnimationScreenState();
}

class _AnimationScreenState extends State<AnimationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late Animation<double> _opacityAnimation;

  bool _showButton = false;
  bool _showLoader = false;
  bool _showList = false;
  bool _showFirstAnimation = true; // Flag to control initial animation visibility

  @override
  void initState() {
    super.initState();

    // Create an AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );

    // Create an animation that moves the widget from left to right
    _animation = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset(1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Create an opacity animation
    _opacityAnimation = Tween<double>(
      begin: 0.1,
      end: 1.0,
    ).animate(_controller);

    // Start the animation
    _controller.forward();

    // Show button after animation completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showButton = true;
        });
      }
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        setState(() {
          _showFirstAnimation = false; // Hide the first animation after 5 seconds
        });
      }
    });
  }

  void _showLoaderAnimation() {
    setState(() {
      _showButton = false;
      _showLoader = true;
    });

    // Simulate loading with a delay
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _showLoader = false;
        _showList = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when the widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Animation'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Animated Loader',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.white,
                  ),
                  if (_showFirstAnimation)
                    Positioned(
                      top: MediaQuery.of(context).size.height / 2 - 25,
                      left: MediaQuery.of(context).size.width / 2 - 25,
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _opacityAnimation.value,
                            child: Transform.translate(
                              offset: _animation.value * 150,
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  if (_showButton)
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: ElevatedButton(
                        onPressed: _showLoaderAnimation,
                        child: Text('Show Loader Animation'),
                      ),
                    ),
                  if (_showLoader)
                    Positioned.fill(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  if (_showList)
                    Positioned.fill(
                      child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text('Item $index'),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
