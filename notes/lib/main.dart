import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/add_notes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Step 1: Create Firebase Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "All Notes",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
        ),
      ),
      body: StreamBuilder(
        stream: _firestore.collection("Users").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  // Step 2: Get document reference and data
                  var document = snapshot.data!.docs[index];
                  var data = document.data() as Map<String, dynamic>;

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getAvatarColor(index),
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(data["Title"] ?? "No Title"),
                    subtitle: Text(data["Description"] ?? "No Description"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Step 3: Pass document ID and data to details screen
                      _showNoteDetails(
                        context,
                        document.id, // Document ID for delete/edit
                        data["Title"] ?? "No Title",
                        data["Description"] ?? "No Description",
                      );
                    },
                  );
                },
                itemCount: snapshot.data!.docs.length,
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("${snapshot.hasError.toString()}"),
              );
            } else {
              return const Center(
                child: Text("No data Found....."),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const addnotes()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Function to show note details with Edit/Delete buttons
  void _showNoteDetails(BuildContext context, String documentId, String title, String description) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                description,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),

              // Edit and Delete Buttons WITH FUNCTIONALITY
              Row(
                children: [
                  // Edit Button - Step 4: Edit functionality
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Close the bottom sheet first
                        Navigator.pop(context);

                        // Open Edit Screen with current data
                        _openEditScreen(context, documentId, title, description);
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text("Edit"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Delete Button - Step 5: Delete functionality
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Call delete function
                        _deleteNote(context, documentId);
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text("Delete"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  // Step 6: DELETE FUNCTION
  Future<void> _deleteNote(BuildContext context, String documentId) async {
    try {
      // Step 6a: Show confirmation dialog
      bool confirmDelete = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Delete Note"),
          content: const Text("Are you sure you want to delete this note?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); // Return false for cancel
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true); // Return true for delete
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );

      // Step 6b: If user confirmed delete
      if (confirmDelete == true) {
        // Close the bottom sheet
        Navigator.pop(context);

        // Step 6c: Delete from Firebase
        await _firestore.collection("Users").doc(documentId).delete();

        // Step 6d: Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Note deleted successfully"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Step 6e: Show error message if delete fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error deleting note: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Step 7: OPEN EDIT SCREEN
  void _openEditScreen(BuildContext context, String documentId, String currentTitle, String currentDescription) {
    // Navigate to EditNoteScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditNoteScreen(
          documentId: documentId,
          currentTitle: currentTitle,
          currentDescription: currentDescription,
        ),
      ),
    );
  }

  // Helper function to get avatar color
  Color _getAvatarColor(int index) {
    List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
    ];
    return colors[index % colors.length];
  }
}

// Step 8: EDIT NOTE SCREEN
class EditNoteScreen extends StatefulWidget {
  final String documentId;
  final String currentTitle;
  final String currentDescription;

  const EditNoteScreen({
    super.key,
    required this.documentId,
    required this.currentTitle,
    required this.currentDescription,
  });

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  // Step 9: Create text controllers
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  // Step 10: Create Firebase instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Step 11: Loading state for save button
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Step 12: Initialize controllers with current values
    _titleController = TextEditingController(text: widget.currentTitle);
    _descriptionController = TextEditingController(text: widget.currentDescription);
  }

  @override
  void dispose() {
    // Step 13: Clean up controllers
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Step 14: UPDATE FUNCTION
  Future<void> _updateNote() async {
    // Get trimmed values
    String newTitle = _titleController.text.trim();
    String newDescription = _descriptionController.text.trim();

    // Step 14a: Validation - check if title is not empty
    if (newTitle.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Title cannot be empty"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Step 14b: Set loading state
    setState(() {
      _isSaving = true;
    });

    try {
      // Step 14c: Update in Firebase
      await _firestore.collection("Users").doc(widget.documentId).update({
        "Title": newTitle,
        "Description": newDescription,
      });

      // Step 14d: Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Note updated successfully"),
          backgroundColor: Colors.green,
        ),
      );

      // Step 14e: Go back to home screen
      Navigator.pop(context);
    } catch (e) {
      // Step 14f: Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error updating note: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // Step 14g: Reset loading state
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Note"),
        actions: [
          // Step 15: Save button in app bar
          IconButton(
            onPressed: _isSaving ? null : _updateNote,
            icon: _isSaving
                ? const CircularProgressIndicator()
                : const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Step 16: Title field
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
                hintText: "Enter note title",
              ),
            ),
            const SizedBox(height: 20),

            // Step 17: Description field
            Expanded(
              child: TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                  hintText: "Enter note description",
                  alignLabelWithHint: true,
                ),
                maxLines: null, // Multiple lines
                expands: true, // Fill available space
                keyboardType: TextInputType.multiline,
              ),
            ),
            const SizedBox(height: 20),

            // Step 18: Save button at bottom
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _updateNote,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "Save Changes",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}