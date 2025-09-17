import 'package:flutter/material.dart';

class SignUpAsAnyoneScreen extends StatefulWidget {
  const SignUpAsAnyoneScreen({super.key});

  @override
  State<SignUpAsAnyoneScreen> createState() => _SignUpAsAnyoneScreenState();
}

class _SignUpAsAnyoneScreenState extends State<SignUpAsAnyoneScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Logo",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            // Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Let’s get started!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Progress indicator (slide bar style)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(3, (index) {
                  return Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 4,
                      decoration: BoxDecoration(
                        color: _currentIndex == index ? Colors.red : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 20),

            // Pages
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: const [
                  Center(child: Text("Page One Content")),
                  Center(child: Text("Page Two Content")),
                  Center(child: Text("Page Three Content")),
                ],
              ),
            ),

            // Next button
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  if (_currentIndex < 2) {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: Text(
                  _currentIndex == 2 ? "Finish" : "Next",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
