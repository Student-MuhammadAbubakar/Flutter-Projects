import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;

  void _handleLogin() {
    setState(() {
      _isLoggedIn = true;
    });
  }

  void _handleLogout() {
    setState(() {
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AZshare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey.shade600,
          type: BottomNavigationBarType.fixed,
        ),
        cardTheme: CardThemeData(
          color: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
            side: BorderSide(color: Colors.grey.shade800, width: 0.5),
          ),
        ),
      ),
      home: _isLoggedIn
          ? MainScreen(onLogout: _handleLogout)
          : LoginPage(onLogin: _handleLogin),
    );
  }
}

// Login Page
// Login Page
class LoginPage extends StatefulWidget {
  final VoidCallback onLogin;

  const LoginPage({super.key, required this.onLogin});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Demo credentials (no database)
  final List<Map<String, String>> _demoUsers = [
    {'username': '@bakar1170', 'password': 'abc1170'},
    {'username': '@abdullah1172', 'password': 'abc1172'},
    {'username': '@ali1131', 'password': 'abc1131'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo
                  const Text(
                    'AZshare',
                    style: TextStyle(
                      fontFamily: 'Billabong',
                      fontSize: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Welcome to AZshare',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Username Field with reduced width
                  SizedBox(
                    width: 300, // Reduced width
                    child: TextFormField(
                      controller: _usernameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade700),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade700),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        prefixIcon: Icon(Icons.person, color: Colors.grey.shade600),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter username';
                        }
                        if (value.length < 3) {
                          return 'Username must be at least 3 characters';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Password Field with reduced width
                  SizedBox(
                    width: 300, // Reduced width
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade700),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade700),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        prefixIcon: Icon(Icons.lock, color: Colors.grey.shade600),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Login Button with reduced width
                  _isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                    width: 300, // Reduced width
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _handleLoginAttempt,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Sign Up Option
                  TextButton(
                    onPressed: () {
                      _showSignUpMessage();
                    },
                    child: const Text(
                      "Don't have an account? Sign Up",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ... rest of the code remains the same

  Future<void> _handleLoginAttempt() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    // Check against demo users
    final isValidUser = _demoUsers.any((user) =>
    user['username'] == username && user['password'] == password);

    if (isValidUser) {
      widget.onLogin();
    } else {
      _showError('Invalid username or password');
    }

    setState(() => _isLoading = false);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSignUpMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            'Sign Up',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Demo version - Please use one of these demo accounts:\n\n'
                'Username: gamewadotv\nPassword: password123\n\n'
                'Username: john_doe\nPassword: password123\n\n'
                'Username: travel_buddy\nPassword: password123',
            style: TextStyle(color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Post model (data structure for posts)
class Post {
  String username;
  String userAvatar;
  File? image;
  String? imageUrl; // Added for network images
  String caption;
  int likes;
  List<String> comments;
  bool isFollowing;
  DateTime timestamp;

  Post({
    required this.username,
    required this.userAvatar,
    this.image,
    this.imageUrl, // Added for network images
    required this.caption,
    this.likes = 0,
    this.comments = const [],
    this.isFollowing = false,
    required this.timestamp,
  });
}

class MainScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const MainScreen({super.key, required this.onLogout});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Post> _allPosts = [];
  List<Post> _searchResults = [];
  final List<Map<String, dynamic>> _notifications = [];
  File? _selectedImage;
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  // Stories variables
  final List<Map<String, dynamic>> _stories = [];
  File? _selectedStoryImage;
  final Map<int, DateTime> _storyStartTimes = {};
  final Map<int, Timer> _storyTimers = {};

  // Bottom navigation pages
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    // Add initial demo posts
    _addDemoPosts();
    // Initialize pages
    _updatePages();
  }

  @override
  void dispose() {
    // Cancel all story timers
    for (var timer in _storyTimers.values) {
      timer.cancel();
    }
    super.dispose();
  }

  void _updatePages() {
    _pages.clear();
    _pages.addAll([
      HomePage(
        posts: _allPosts,
        onLike: _toggleLike,
        onComment: _addComment,
        onFollow: _toggleFollow,
        stories: _stories,
        onAddStory: _pickStoryImage,
        key: ValueKey(_allPosts.length + _stories.length),
      ),
      SearchPage(
        posts: _allPosts,
        searchController: _searchController,
        onSearch: _performSearch,
        searchResults: _searchResults,
        key: ValueKey(_searchResults.length),
      ),
      Container(color: Colors.black),
      NotificationsPage(
        notifications: _notifications,
        key: ValueKey(_notifications.length),
      ),
      ProfilePage(
        posts: _allPosts.where((post) => post.username == 'You').toList(),
        key: ValueKey(_allPosts.where((post) => post.username == 'You').length),
      ),
    ]);
  }

  void _addDemoPosts() {
    setState(() {
      _allPosts.addAll([
        Post(
          username: 'gamewadotv',
          userAvatar: '',
          imageUrl: 'https://images.unsplash.com/photo-1593305841991-05c297ba4575?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          caption: 'Court rejects Ducky Bhai\'s plea for return of YouTube channel 🚫',
          likes: 2450,
          comments: ['This is crazy!', 'Justice served', 'Free Ducky!'],
          isFollowing: false,
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Post(
          username: 'john_doe',
          userAvatar: '',
          imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          caption: 'Beautiful sunset at the beach! 🌅✨ #sunset #beachvibes',
          likes: 1200,
          comments: ['Amazing view!', 'Where is this?', 'Stunning!'],
          isFollowing: false,
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        Post(
          username: 'travel_buddy',
          userAvatar: '',
          imageUrl: 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          caption: 'Exploring new places and making memories! ✈️🗺️',
          likes: 850,
          comments: ['Wish I was there!', 'Safe travels!'],
          isFollowing: false,
          timestamp: DateTime.now().subtract(const Duration(hours: 12)),
        ),
        Post(
          username: 'foodie_guru',
          userAvatar: '',
          imageUrl: 'https://images.unsplash.com/photo-1565958011703-44f9829ba187?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          caption: 'Homemade pizza night! 🍕 Who wants a slice? 😋',
          likes: 920,
          comments: ['Recipe please!', 'Looks delicious!'],
          isFollowing: false,
          timestamp: DateTime.now().subtract(const Duration(hours: 8)),
        ),
        Post(
          username: 'nature_lover',
          userAvatar: '',
          imageUrl: 'https://images.unsplash.com/photo-1439066615861-d1af74d74000?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          caption: 'Morning hike in the mountains! 🏔️ Nature is the best therapy. #nature #hiking',
          likes: 1560,
          comments: ['Beautiful!', 'What trail is this?', 'Love it!'],
          isFollowing: false,
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
        ),
        Post(
          username: 'tech_guru',
          userAvatar: '',
          imageUrl: 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          caption: 'Just set up my new workspace! 💻 What do you think? #setup #tech',
          likes: 1890,
          comments: ['Awesome setup!', 'Specs?', 'So clean!'],
          isFollowing: false,
          timestamp: DateTime.now().subtract(const Duration(hours: 20)),
        ),
      ]);
      _updatePages();
    });
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      _showCreatePostDialog();
    }
  }

  Future<void> _pickStoryImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedStoryImage = File(pickedFile.path);
      });
      _uploadStory();
    }
  }

  void _uploadStory() {
    if (_selectedStoryImage != null) {
      final storyId = DateTime.now().millisecondsSinceEpoch;
      final newStory = {
        'id': storyId,
        'image': _selectedStoryImage!,
        'username': 'You',
        'uploadTime': DateTime.now(),
      };

      setState(() {
        _stories.insert(0, newStory);
        _storyStartTimes[storyId] = DateTime.now();
        _updatePages();
      });

      // Clear selected image
      _selectedStoryImage = null;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Story uploaded! It will disappear in 30 seconds.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Start timer to remove story after 30 seconds
      final timer = Timer(const Duration(seconds: 30), () {
        if (mounted) {
          setState(() {
            _stories.removeWhere((story) => story['id'] == storyId);
            _storyStartTimes.remove(storyId);
            _storyTimers.remove(storyId);
            _updatePages();
          });

          // Show story expired message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your story has expired.'),
              backgroundColor: Colors.grey,
              duration: Duration(seconds: 2),
            ),
          );
        }
      });

      _storyTimers[storyId] = timer;
    }
  }

  void _showCreatePostDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            'Create New Post',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_selectedImage != null)
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: FileImage(_selectedImage!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                TextField(
                  controller: _captionController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Write a caption...',
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade700),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade700),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                  ),
                  maxLines: 4,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _selectedImage = null;
                _captionController.clear();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_selectedImage != null) {
                  _createPost();
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
              ),
              child: const Text('Post'),
            ),
          ],
        );
      },
    );
  }

  void _createPost() {
    if (_selectedImage != null) {
      final newPost = Post(
        username: 'You',
        userAvatar: '',
        image: _selectedImage!,
        caption: _captionController.text.isNotEmpty ? _captionController.text : 'Shared a photo',
        likes: 0,
        comments: [],
        isFollowing: false,
        timestamp: DateTime.now(),
      );

      setState(() {
        _allPosts.insert(0, newPost);

        // Add notification for new post
        _notifications.insert(0, {
          'id': DateTime.now().millisecondsSinceEpoch,
          'type': 'new_post',
          'username': 'You',
          'message': 'added a new post',
          'time': 'Just now',
          'postImage': newPost.image,
          'timestamp': DateTime.now(),
        });

        _updatePages();
      });

      _selectedImage = null;
      _captionController.clear();

      setState(() {
        _currentIndex = 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _addComment(int postIndex, String comment) {
    setState(() {
      _allPosts[postIndex].comments.add(comment);

      // Add notification for comment
      _notifications.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch + 1,
        'type': 'comment',
        'username': 'You',
        'message': 'commented: "$comment"',
        'time': 'Just now',
        'postImage': _allPosts[postIndex].image,
        'timestamp': DateTime.now(),
      });

      _updatePages();
    });
  }

  void _toggleLike(int postIndex) {
    setState(() {
      final post = _allPosts[postIndex];
      post.likes = post.likes == 0 ? 1 : 0;

      // Add notification for like
      if (post.likes > 0) {
        _notifications.insert(0, {
          'id': DateTime.now().millisecondsSinceEpoch + 2,
          'type': 'like',
          'username': 'You',
          'message': 'liked your post',
          'time': 'Just now',
          'postImage': post.image,
          'timestamp': DateTime.now(),
        });
      }
      _updatePages();
    });
  }

  void _toggleFollow(int postIndex) {
    setState(() {
      _allPosts[postIndex].isFollowing = !_allPosts[postIndex].isFollowing;
      if (_allPosts[postIndex].isFollowing && _allPosts[postIndex].username != 'You') {
        _notifications.insert(0, {
          'id': DateTime.now().millisecondsSinceEpoch + 3,
          'type': 'follow',
          'username': 'You',
          'message': 'started following ${_allPosts[postIndex].username}',
          'time': 'Just now',
          'timestamp': DateTime.now(),
        });
      }
      _updatePages();
    });
  }

  void _performSearch(String query) {
    setState(() {
      _searchResults = _allPosts.where((post) {
        return post.username.toLowerCase().contains(query.toLowerCase()) ||
            post.caption.toLowerCase().contains(query.toLowerCase()) ||
            post.comments.any((comment) => comment.toLowerCase().contains(query.toLowerCase()));
      }).toList();
      _updatePages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 28),
          onPressed: () {},
        ),
        title: const Text(
          'AZshare',
          style: TextStyle(
            fontFamily: 'Billabong',
            fontSize: 34,
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
        ),
        centerTitle: true,
        actions: [
          // Logout button (replaces the message icon)
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
              size: 28,
            ),
            onPressed: widget.onLogout,
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(_currentIndex == 0 ? Icons.home_filled : Icons.home_outlined, size: 28),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(_currentIndex == 1 ? Icons.search : Icons.search_outlined, size: 28),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined, size: 28),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(_currentIndex == 3 ? Icons.favorite : Icons.favorite_border, size: 28),
                if (_notifications.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                    ),
                  ),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(_currentIndex == 4 ? Icons.person : Icons.person_outline, size: 28),
            label: '',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 2
          ? FloatingActionButton(
        onPressed: _pickImage,
        backgroundColor: Colors.blue.shade600,
        child: const Icon(Icons.add, size: 28),
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

// Home Page Widget - Centers all posts
class HomePage extends StatefulWidget {
  final List<Post> posts;
  final Function(int) onLike;
  final Function(int, String) onComment;
  final Function(int) onFollow;
  final List<Map<String, dynamic>> stories;
  final VoidCallback onAddStory;

  const HomePage({
    super.key,
    required this.posts,
    required this.onLike,
    required this.onComment,
    required this.onFollow,
    required this.stories,
    required this.onAddStory,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<int, TextEditingController> _commentControllers = {};
  Timer? _storyUpdateTimer;

  @override
  void initState() {
    super.initState();
    // Start timer to update story progress every second
    _storyUpdateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && widget.stories.isNotEmpty) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _storyUpdateTimer?.cancel();
    super.dispose();
  }

  int _getStoryRemainingTime(Map<String, dynamic> story) {
    final uploadTime = story['uploadTime'] as DateTime?;
    if (uploadTime == null) return 0;

    final now = DateTime.now();
    final difference = now.difference(uploadTime);
    final secondsPassed = difference.inSeconds;
    final remaining = 30 - secondsPassed;

    return remaining > 0 ? remaining : 0;
  }

  double _getStoryProgress(Map<String, dynamic> story) {
    final uploadTime = story['uploadTime'] as DateTime?;
    if (uploadTime == null) return 0.0;

    final now = DateTime.now();
    final difference = now.difference(uploadTime);
    final secondsPassed = difference.inSeconds;

    return secondsPassed / 30.0;
  }

  @override
  Widget build(BuildContext context) {
    return widget.posts.isEmpty
        ? Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo_library_outlined, size: 80, color: Colors.grey.shade700),
          const SizedBox(height: 20),
          Text(
            'No posts yet',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Text(
            'Create your first post!',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
        ],
      ),
    )
        : SingleChildScrollView(
      child: Column(
        children: [
          // Stories section - FIXED with proper height
          Container(
            height: 110, // Fixed height to prevent overflow
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.stories.length + 1, // +1 for add story button
              itemBuilder: (context, index) {
                // First item is "Add Story" button
                if (index == 0) {
                  return Container(
                    width: 70,
                    margin: const EdgeInsets.only(left: 12, right: 8),
                    child: Column(
                      children: [
                        // Add Story Button
                        GestureDetector(
                          onTap: widget.onAddStory,
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade900,
                              border: Border.all(color: Colors.grey.shade700, width: 2),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Your story',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                }

                // Story items
                final storyIndex = index - 1;
                if (storyIndex < widget.stories.length) {
                  final story = widget.stories[storyIndex];
                  final progress = _getStoryProgress(story);
                  final remainingTime = _getStoryRemainingTime(story);

                  return Container(
                    width: 70,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        // Story progress indicator
                        if (progress < 1.0 && story['username'] == 'You')
                          Container(
                            height: 2,
                            width: 64,
                            margin: const EdgeInsets.only(bottom: 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(1),
                              child: LinearProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.grey.shade800,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  progress > 0.8 ? Colors.red : Colors.blue,
                                ),
                              ),
                            ),
                          )
                        else
                          const SizedBox(height: 6),

                        // Story circle with gradient border
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.purple.shade600,
                                Colors.orange.shade600,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                                border: Border.all(color: Colors.black, width: 2),
                              ),
                              child: story['image'] != null
                                  ? ClipOval(
                                child: Image.file(
                                  story['image'] as File,
                                  fit: BoxFit.cover,
                                  width: 60,
                                  height: 60,
                                ),
                              )
                                  : CircleAvatar(
                                backgroundColor: Colors.grey.shade800,
                                child: Text(
                                  (story['username'] as String)[0],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Username with time remaining
                        Column(
                          children: [
                            Text(
                              story['username'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (remainingTime > 0 && story['username'] == 'You')
                              Text(
                                '${remainingTime}s',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                }

                return Container();
              },
            ),
          ),
          // Posts list
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.posts.length,
            itemBuilder: (context, index) {
              if (!_commentControllers.containsKey(index)) {
                _commentControllers[index] = TextEditingController();
              }
              return Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: PostCard(
                    post: widget.posts[index],
                    onLike: () => widget.onLike(index),
                    onComment: (comment) => widget.onComment(index, comment),
                    onFollow: () => widget.onFollow(index),
                    commentController: _commentControllers[index]!,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Post Card Widget
class PostCard extends StatefulWidget {
  final Post post;
  final VoidCallback onLike;
  final Function(String) onComment;
  final VoidCallback onFollow;
  final TextEditingController commentController;

  const PostCard({
    super.key,
    required this.post,
    required this.onLike,
    required this.onComment,
    required this.onFollow,
    required this.commentController,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isLiked = false;
  bool _isSaved = false;
  bool _showAllComments = false;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.post.likes > 0;
  }

  String _formatTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.shade600,
                  radius: 20,
                  child: Text(
                    widget.post.username[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        _formatTimeAgo(widget.post.timestamp),
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.post.username != 'You')
                  GestureDetector(
                    onTap: () {
                      widget.onFollow();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: widget.post.isFollowing ? Colors.grey.shade800 : Colors.blue.shade600,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        widget.post.isFollowing ? 'Following' : 'Follow',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.grey.shade900,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 10),
                            Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade600,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildMenuOption(Icons.report, 'Report', Colors.red),
                            _buildMenuOption(Icons.block, 'Block', Colors.white),
                            _buildMenuOption(Icons.link, 'Copy Link', Colors.white),
                            _buildMenuOption(Icons.share, 'Share to...', Colors.white),
                            _buildMenuOption(Icons.bookmark_border, 'Save', Colors.white),
                            const SizedBox(height: 20),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                ),
              ],
            ),
          ),

          // Post image
          if (widget.post.image != null || widget.post.imageUrl != null)
            Container(
              height: 400,
              width: double.infinity,
              color: Colors.grey.shade900,
              child: widget.post.image != null
                  ? Image.file(
                widget.post.image!,
                fit: BoxFit.cover,
              )
                  : Image.network(
                widget.post.imageUrl!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.broken_image, size: 80, color: Colors.grey.shade600),
                        const SizedBox(height: 10),
                        const Text(
                          'Failed to load image',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          else
            Container(
              height: 400,
              color: Colors.grey.shade900,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_outlined, size: 80, color: Colors.grey.shade600),
                    const SizedBox(height: 10),
                    const Text(
                      'No Image',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isLiked = !_isLiked;
                          widget.onLike();
                        });
                      },
                      icon: Icon(
                        _isLiked ? Icons.favorite : Icons.favorite_border,
                        color: _isLiked ? Colors.red : Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      icon: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.send_outlined, color: Colors.white, size: 26),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isSaved = !_isSaved;
                    });
                    // Add notification for save
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_isSaved ? 'Post saved to favorites' : 'Post removed from favorites'),
                        backgroundColor: Colors.grey.shade800,
                      ),
                    );
                  },
                  icon: Icon(
                    _isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: _isSaved ? Colors.yellow : Colors.white,
                    size: 26,
                  ),
                ),
              ],
            ),
          ),

          // Likes count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '${widget.post.likes} likes',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Caption
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${widget.post.username} ',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: widget.post.caption,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Comments section
          if (widget.post.comments.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // View all comments button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showAllComments = !_showAllComments;
                      });
                    },
                    child: Text(
                      _showAllComments
                          ? 'Hide comments'
                          : 'View all ${widget.post.comments.length} comments',
                      style: TextStyle(
                        color: Colors.blue.shade400,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Comments list
                  ...(_showAllComments
                      ? widget.post.comments
                      : widget.post.comments.take(2))
                      .map((comment) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.grey.shade800,
                            child: Text(
                              widget.post.username[0],
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.post.username,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  comment,
                                  style: TextStyle(
                                    color: Colors.grey.shade300,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),

          // Add comment section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey.shade800,
                  child: const Text(
                    'Y',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: widget.commentController,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (widget.commentController.text.isNotEmpty) {
                      widget.onComment(widget.commentController.text);
                      widget.commentController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Comment added!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.blue.shade400,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildMenuOption(IconData icon, String text, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$text selected'),
            backgroundColor: Colors.grey.shade800,
          ),
        );
      },
    );
  }
}

// Search Page Widget
class SearchPage extends StatelessWidget {
  final List<Post> posts;
  final TextEditingController searchController;
  final Function(String) onSearch;
  final List<Post> searchResults;

  const SearchPage({
    super.key,
    required this.posts,
    required this.searchController,
    required this.onSearch,
    required this.searchResults,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: searchController,
            onChanged: onSearch,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search posts, users, comments...',
              hintStyle: TextStyle(color: Colors.grey.shade500),
              prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
              filled: true,
              fillColor: Colors.grey.shade900,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        // Search results
        Expanded(
          child: searchController.text.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search, size: 80, color: Colors.grey.shade700),
                const SizedBox(height: 20),
                Text(
                  'Search for posts',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try searching by username or caption',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
          )
              : searchResults.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 80, color: Colors.grey.shade700),
                const SizedBox(height: 20),
                Text(
                  'No results found',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try different keywords',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
          )
              : ListView.builder(
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              final post = searchResults[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: post.image != null
                              ? Image.file(post.image!, fit: BoxFit.cover)
                              : post.imageUrl != null
                              ? Image.network(post.imageUrl!, fit: BoxFit.cover)
                              : Center(
                            child:
                            Icon(Icons.image, color: Colors.grey.shade500),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.username,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                post.caption,
                                style: TextStyle(color: Colors.grey.shade300),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${post.likes} likes • ${post.comments.length} comments',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Notifications Page Widget
class NotificationsPage extends StatelessWidget {
  final List<Map<String, dynamic>> notifications;

  const NotificationsPage({super.key, required this.notifications});

  String _formatNotificationTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return notifications.isEmpty
        ? Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 80, color: Colors.grey.shade700),
          const SizedBox(height: 20),
          Text(
            'No notifications yet',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            'When you post, like, comment or follow,\nyou\'ll see notifications here.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
        ],
      ),
    )
        : ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        final timestamp = notification['timestamp'] as DateTime? ?? DateTime.now();

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade600,
                child: Text(
                  notification['username'][0].toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: notification['username'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' ${notification['message']}',
                      style: const TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              subtitle: Text(
                _formatNotificationTime(timestamp),
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
              trailing: notification['postImage'] != null
                  ? Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  image: DecorationImage(
                    image: FileImage(notification['postImage'] as File),
                    fit: BoxFit.cover,
                  ),
                ),
              )
                  : Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  Icons.notifications,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Profile Page Widget
class ProfilePage extends StatelessWidget {
  final List<Post> posts;

  const ProfilePage({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.blue.shade600,
                      child: const Text(
                        'Y',
                        style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            posts.length.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Posts',
                            style: TextStyle(color: Colors.grey.shade400),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        const Text(
                          '0',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Followers',
                          style: TextStyle(color: Colors.grey.shade400),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        const Text(
                          '0',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Following',
                          style: TextStyle(color: Colors.grey.shade400),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'You',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade800,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Edit Profile'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade800,
                        foregroundColor: Colors.white,
                      ),
                      child: const Icon(Icons.person_add),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Posts grid
          if (posts.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.grey.shade900,
                  child: posts[index].image != null
                      ? Image.file(posts[index].image!, fit: BoxFit.cover)
                      : posts[index].imageUrl != null
                      ? Image.network(posts[index].imageUrl!, fit: BoxFit.cover)
                      : Center(
                    child: Icon(Icons.image, color: Colors.grey.shade600),
                  ),
                );
              },
            )
          else
            Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade700, width: 2),
                    ),
                    child: Icon(Icons.add_a_photo, size: 40, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Share Photos',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'When you share photos, they will appear on your profile.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Share your first photo'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}