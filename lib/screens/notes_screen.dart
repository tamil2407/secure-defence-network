import 'package:flutter/material.dart'; 
import '../theme/app_theme.dart'; 
 
class NoteItem { 
  String title; 
  String content; 
  DateTime createdAt; 
  bool isPinned; 
  bool isFavorite; 
 
  NoteItem({ 
    required this.title, 
    required this.content, 
    required this.createdAt, 
    this.isPinned = false, 
    this.isFavorite = false, 
  }); 
} 
 
class NotesScreen extends StatefulWidget { 
  const NotesScreen({super.key}); 
 
  @override 
  State<NotesScreen> createState() => _NotesScreenState(); 
} 
 
class _NotesScreenState extends State<NotesScreen> { 
  final TextEditingController _searchController = TextEditingController(); 
 
  final List<NoteItem> _notes = [ 
    NoteItem( 
      title: 'Mission Brief', 
      content: 'Check encrypted communication channel before team deployment. Verify all squad access credentials.', 
      createdAt: DateTime.now().subtract(const Duration(hours: 2)), 
      isPinned: true, 
    ), 
    NoteItem( 
      title: 'Daily Security Reminder', 
      content: 'Do not share command center login details. Change backup passcode every 7 days.', 
      createdAt: DateTime.now().subtract(const Duration(days: 1)), 
      isFavorite: true, 
    ), 
    NoteItem(
      title: 'Field Observation', 
      content: 'North checkpoint signal strength dropped briefly at 09:20 AM. Investigate relay node.', 
      createdAt: DateTime.now().subtract(const Duration(days: 2)), 
    ), 
  ]; 
 
  String _selectedFilter = 'All'; 
 
  @override 
  void dispose() { 
    _searchController.dispose(); 
    super.dispose(); 
  } 
 
  List<NoteItem> get _filteredNotes { 
    List<NoteItem> result = List.from(_notes); 
 
    if (_selectedFilter == 'Pinned') { 
      result = result.where((note) => note.isPinned).toList(); 
    } else if (_selectedFilter == 'Favorites') { 
      result = result.where((note) => note.isFavorite).toList(); 
    } 
 
    final query = _searchController.text.trim().toLowerCase(); 
    if (query.isNotEmpty) { 
      result = result.where((note) { 
        return note.title.toLowerCase().contains(query) || 
            note.content.toLowerCase().contains(query); 
      }).toList(); 
    } 
 
    result.sort((a, b) { 
      if (a.isPinned && !b.isPinned) return -1; 
      if (!a.isPinned && b.isPinned) return 1; 
      return b.createdAt.compareTo(a.createdAt); 
    }); 
 
    return result; 
  } 
 
  int get _pinnedCount => _notes.where((n) => n.isPinned).length; 
  int get _favoriteCount => _notes.where((n) => n.isFavorite).length; 
 
  @override
  Widget build(BuildContext context) {
    final themeController = ThemeScope.of(context);
    final c = themeController.colors;

    return Scaffold(
      backgroundColor: c.surfaceSoft,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopCard(c),
              const SizedBox(height: 18),
              _buildSearchBar(c),
              const SizedBox(height: 18),
              _buildFilterTabs(c),
              const SizedBox(height: 18),
              _buildNotesList(c),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: c.primary,
        onPressed: () => _openNoteEditor(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _openNoteEditor({NoteItem? note, int? index}) { 
    final themeController = ThemeScope.of(context); 
    final c = themeController.colors; 
 
    final TextEditingController titleController = 
        TextEditingController(text: note?.title ?? ''); 
    final TextEditingController contentController = 
        TextEditingController(text: note?.content ?? ''); 
 
    showModalBottomSheet( 
      context: context, 
      isScrollControlled: true, 
      backgroundColor: c.surface, 
      shape: const RoundedRectangleBorder( 
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)), 
      ), 
      builder: (context) { 
        final bottomC = ThemeScope.of(context).colors; 
 
        return Padding( 
          padding: EdgeInsets.only( 
            left: 18, 
            right: 18, 
            top: 18, 
            bottom: MediaQuery.of(context).viewInsets.bottom + 18, 
          ), 
          child: SingleChildScrollView( 
            child: Column( 
              mainAxisSize: MainAxisSize.min, 
              children: [ 
                Container( 
                  width: 55, 
                  height: 5, 
                  decoration: BoxDecoration( 
                    color: bottomC.textMuted.withOpacity(0.5), 
                    borderRadius: BorderRadius.circular(20), 
                  ), 
                ), 
                const SizedBox(height: 18), 
                Text( 
                  note == null ? 'Create Secure Note' : 'Edit Secure Note', 
                  style: TextStyle( 
                    color: bottomC.textPrimary, 
                    fontSize: 19, 
                    fontWeight: FontWeight.bold, 
                  ), 
                ), 
                const SizedBox(height: 18), 
                TextField( 
                  controller: titleController, 
                  style: TextStyle(color: bottomC.textPrimary), 
                  decoration: InputDecoration( 
                    hintText: 'Enter note title', 
                    hintStyle: TextStyle(color: bottomC.textMuted), 
                    filled: true, 
                    fillColor: bottomC.surfaceSoft, 
                    border: OutlineInputBorder( 
                      borderRadius: BorderRadius.circular(14), 
                      borderSide: BorderSide.none, 
                    ), 
                  ), 
                ), 
                const SizedBox(height: 14), 
                TextField( 
                  controller: contentController, 
                  maxLines: 6, 
                  style: TextStyle(color: bottomC.textPrimary), 
                  decoration: InputDecoration( 
                    hintText: 'Write secure note details', 
                    hintStyle: TextStyle(color: bottomC.textMuted), 
                    filled: true, 
                    fillColor: bottomC.surfaceSoft, 
                    border: OutlineInputBorder( 
                      borderRadius: BorderRadius.circular(14), 
                      borderSide: BorderSide.none, 
                    ), 
                  ), 
                ), 
                const SizedBox(height: 18), 
                SizedBox( 
                  width: double.infinity, 
                  child: ElevatedButton.icon( 
                    onPressed: () { 
                      final title = titleController.text.trim(); 
                      final content = contentController.text.trim(); 
 
                      if (title.isEmpty || content.isEmpty) { 
                        ScaffoldMessenger.of(context).showSnackBar( 
                          const SnackBar( 
                            content: Text('Please enter both title and content'), 
                          ), 
                        ); 
                        return; 
                      } 
 
                      setState(() { 
                        if (note == null) { 
                          _notes.insert( 
                            0, 
                            NoteItem( 
                              title: title, 
                              content: content, 
                              createdAt: DateTime.now(), 
                            ), 
                          ); 
                        } else if (index != null) { 
                          _notes[index].title = title; 
                          _notes[index].content = content; 
                          _notes[index].createdAt = DateTime.now(); 
                        } 
                      }); 
 
                      Navigator.pop(context); 
                    }, 
                    style: ElevatedButton.styleFrom( 
                      backgroundColor: bottomC.primary, 
                      padding: const EdgeInsets.symmetric(vertical: 14), 
                      shape: RoundedRectangleBorder( 
                        borderRadius: BorderRadius.circular(14), 
                      ), 
                    ), 
                    icon: const Icon(Icons.save_outlined, color: Colors.white), 
                    label: Text( 
                      note == null ? 'Save Note' : 'Update Note', 
                      style: const TextStyle( 
                        color: Colors.white, 
                        fontWeight: FontWeight.w600, 
                      ), 
                    ), 
                  ), 
                ), 
              ], 
            ), 
          ), 
        ); 
      }, 
    ); 
  } 
 
  void _deleteNote(int index) { 
    showDialog( 
      context: context, 
      builder: (context) { 
        final dialogC = ThemeScope.of(context).colors; 
 
        return AlertDialog( 
          backgroundColor: dialogC.surface, 
          shape: RoundedRectangleBorder( 
            borderRadius: BorderRadius.circular(20), 
          ), 
          title: Text( 
            'Delete Note', 
            style: TextStyle(color: dialogC.textPrimary), 
          ), 
          content: Text( 
            'Are you sure you want to delete this note?', 
            style: TextStyle(color: dialogC.textSecondary), 
          ), 
          actions: [ 
            TextButton( 
              onPressed: () => Navigator.pop(context), 
              child: Text( 
                'Cancel', 
                style: TextStyle(color: dialogC.textSecondary), 
              ), 
            ), 
            TextButton( 
              onPressed: () { 
                setState(() { 
                  _notes.removeAt(index); 
                }); 
                Navigator.pop(context); 
              }, 
              child: const Text( 
                'Delete', 
                style: TextStyle(color: Colors.redAccent), 
              ), 
            ), 
          ], 
        ); 
      }, 
    ); 
  } 
 
  String _formatDate(DateTime dateTime) { 
    final day = dateTime.day.toString().padLeft(2, '0'); 
    final month = dateTime.month.toString().padLeft(2, '0'); 
    final year = dateTime.year.toString(); 
 
    int hour = dateTime.hour; 
    final minute = dateTime.minute.toString().padLeft(2, '0'); 
    final period = hour >= 12 ? 'PM' : 'AM'; 
    hour = hour % 12; 
    if (hour == 0) hour = 12; 
 
    return '$day/$month/$year  ${hour.toString().padLeft(2, '0')}:$minute $period'; 
  } 
 
  BoxDecoration _box(AppColors c) { 
    return BoxDecoration( 
      color: c.surface, 
      borderRadius: BorderRadius.circular(24), 
      border: Border.all(color: c.border), 
      boxShadow: [ 
        BoxShadow( 
          color: c.shadow.withOpacity(0.16), 
          blurRadius: 16, 
          offset: const Offset(0, 6), 
        ), 
      ], 
    ); 
  } 
 
  Widget _buildTopCard(AppColors c) { 
    return Container( 
      width: double.infinity, 
      padding: const EdgeInsets.all(18), 
      decoration: BoxDecoration( 
        gradient: LinearGradient( 
          colors: [c.headerStart, c.headerEnd], 
          begin: Alignment.topLeft, 
          end: Alignment.bottomRight, 
        ), 
        borderRadius: BorderRadius.circular(24), 
        boxShadow: [ 
          BoxShadow( 
            color: c.primary.withOpacity(0.20), 
            blurRadius: 18, 
            offset: const Offset(0, 8), 
          ), 
        ], 
      ), 
      child: Column( 
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [ 
          const Row( 
            children: [ 
              Icon(Icons.description_outlined, color: Colors.white, size: 26), 
              SizedBox(width: 10), 
              Text( 
                'Personal Notes Vault', 
                style: TextStyle( 
                  color: Colors.white, 
                  fontSize: 19, 
                  fontWeight: FontWeight.bold, 
                ), 
              ), 
            ], 
          ), 
          const SizedBox(height: 10), 
          Text( 
            'Store mission reminders, private observations, and secured text records.', 
            style: TextStyle( 
              color: Colors.white.withOpacity(0.82), 
              fontSize: 13, 
              height: 1.4, 
            ), 
          ), 
          const SizedBox(height: 16), 
          Row( 
            children: [ 
              Expanded( 
                child: _buildStatCard( 
                  c: c, 
                  label: 'Total', 
                  value: _notes.length.toString(), 
                  icon: Icons.note_alt_outlined, 
                  color: c.secondary, 
                ), 
              ), 
              const SizedBox(width: 10), 
              Expanded( 
                child: _buildStatCard( 
                  c: c, 
                  label: 'Pinned', 
                  value: _pinnedCount.toString(), 
                  icon: Icons.push_pin_outlined, 
                  color: c.success, 
                ), 
              ), 
              const SizedBox(width: 10), 
              Expanded( 
                child: _buildStatCard( 
                  c: c, 
                  label: 'Favorites', 
                  value: _favoriteCount.toString(), 
                  icon: Icons.star_border, 
                  color: c.warning, 
                ), 
              ), 
            ], 
          ), 
        ], 
      ), 
    ); 
  } 
 
  Widget _buildStatCard({ 
    required AppColors c, 
    required String label, 
    required String value, 
    required IconData icon, 
    required Color color, 
  }) { 
    return Container( 
      padding: const EdgeInsets.symmetric(vertical: 14), 
      decoration: BoxDecoration( 
        color: Colors.white.withOpacity(0.08), 
        borderRadius: BorderRadius.circular(16), 
        border: Border.all(color: Colors.white.withOpacity(0.10)), 
      ), 
      child: Column( 
        children: [ 
          Icon(icon, color: color, size: 20), 
          const SizedBox(height: 8), 
          Text( 
            value, 
            style: const TextStyle( 
              color: Colors.white, 
              fontSize: 17, 
              fontWeight: FontWeight.bold, 
            ), 
          ), 
          const SizedBox(height: 4), 
          Text( 
            label, 
            style: TextStyle( 
              color: Colors.white.withOpacity(0.78), 
              fontSize: 11, 
            ), 
          ), 
        ], 
      ), 
    ); 
  } 
 
  Widget _buildSearchBar(AppColors c) { 
    return TextField( 
      controller: _searchController, 
      onChanged: (value) { 
        setState(() {}); 
      }, 
      style: TextStyle(color: c.textPrimary), 
      decoration: InputDecoration( 
        hintText: 'Search secure notes', 
        hintStyle: TextStyle(color: c.textMuted), 
        prefixIcon: Icon(Icons.search, color: c.textMuted), 
        suffixIcon: _searchController.text.isNotEmpty 
            ? IconButton( 
                onPressed: () { 
                  _searchController.clear(); 
                  setState(() {}); 
                }, 
                icon: Icon(Icons.close, color: c.textMuted), 
              ) 
            : null, 
        filled: true, 
        fillColor: c.surface, 
        contentPadding: const EdgeInsets.symmetric(vertical: 18), 
        border: OutlineInputBorder( 
          borderRadius: BorderRadius.circular(18), 
          borderSide: BorderSide(color: c.border), 
        ), 
        enabledBorder: OutlineInputBorder( 
          borderRadius: BorderRadius.circular(18), 
          borderSide: BorderSide(color: c.border), 
        ), 
        focusedBorder: OutlineInputBorder( 
          borderRadius: BorderRadius.circular(18), 
          borderSide: BorderSide(color: c.primary), 
        ), 
      ), 
    ); 
  } 
 
  Widget _buildFilterTabs(AppColors c) { 
    return Row( 
      children: [ 
        _buildFilterButton(c, 'All'), 
        const SizedBox(width: 10), 
        _buildFilterButton(c, 'Pinned'), 
        const SizedBox(width: 10), 
        _buildFilterButton(c, 'Favorites'), 
      ], 
    ); 
  } 
 
  Widget _buildFilterButton(AppColors c, String label) { 
    final bool isSelected = _selectedFilter == label; 
 
    return Expanded( 
      child: GestureDetector( 
        onTap: () { 
          setState(() { 
            _selectedFilter = label; 
          }); 
        }, 
        child: AnimatedContainer( 
          duration: const Duration(milliseconds: 180), 
          padding: const EdgeInsets.symmetric(vertical: 14), 
          decoration: BoxDecoration( 
            color: isSelected ? c.primary : c.surface, 
            borderRadius: BorderRadius.circular(16), 
            border: Border.all( 
              color: isSelected ? c.primary : c.border, 
            ), 
            boxShadow: isSelected 
                ? [ 
                    BoxShadow( 
                      color: c.primary.withOpacity(0.18), 
                      blurRadius: 10, 
                      offset: const Offset(0, 4), 
                    ), 
                  ] 
                : [], 
          ), 
          child: Text( 
            label, 
            textAlign: TextAlign.center, 
            style: TextStyle( 
              color: isSelected ? Colors.white : c.textPrimary, 
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600, 
            ), 
          ), 
        ), 
      ), 
    ); 
  } 
 
  Widget _buildNotesList(AppColors c) { 
    final notes = _filteredNotes; 
 
    if (notes.isEmpty) { 
      return Container( 
        width: double.infinity, 
        padding: const EdgeInsets.all(30), 
        decoration: _box(c), 
        child: Column( 
          children: [ 
            Icon(Icons.note_add_outlined, color: c.textMuted, size: 44), 
            const SizedBox(height: 12), 
            Text( 
              'No notes found', 
              style: TextStyle( 
                color: c.textPrimary, 
                fontSize: 16, 
                fontWeight: FontWeight.w600, 
              ), 
            ), 
            const SizedBox(height: 6), 
            Text( 
              'Create a new note or change search/filter.', 
              textAlign: TextAlign.center, 
              style: TextStyle( 
                color: c.textSecondary, 
                fontSize: 13, 
              ), 
            ), 
          ], 
        ), 
      ); 
    } 
 
    return Column( 
      children: List.generate(notes.length, (visibleIndex) { 
        final note = notes[visibleIndex]; 
        final originalIndex = _notes.indexOf(note); 
 
        return Container( 
          margin: const EdgeInsets.only(bottom: 14), 
          padding: const EdgeInsets.all(16), 
          decoration: _box(c), 
          child: Column( 
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [ 
              Row( 
                children: [ 
                  if (note.isPinned) 
                    Container( 
                      margin: const EdgeInsets.only(right: 8), 
                      child: Icon( 
                        Icons.push_pin, 
                        color: c.success, 
                        size: 18, 
                      ), 
                    ), 
                  if (note.isFavorite) 
                    Container( 
                      margin: const EdgeInsets.only(right: 8), 
                      child: Icon( 
                        Icons.star, 
                        color: c.warning, 
                        size: 18, 
                      ), 
                    ), 
                  Expanded( 
                    child: Text( 
                      note.title, 
                      style: TextStyle( 
                        color: c.textPrimary, 
                        fontSize: 17, 
                        fontWeight: FontWeight.bold, 
                      ), 
                    ), 
                  ), 
                  PopupMenuButton<String>( 
                    color: c.surface, 
                    icon: Icon(Icons.more_vert, color: c.textSecondary), 
                    onSelected: (value) { 
                      if (value == 'edit') { 
                        _openNoteEditor(note: note, index: originalIndex); 
                      } else if (value == 'pin') { 
                        setState(() { 
                          _notes[originalIndex].isPinned = 
                              !_notes[originalIndex].isPinned; 
                        }); 
                      } else if (value == 'favorite') { 
                        setState(() { 
                          _notes[originalIndex].isFavorite = 
                              !_notes[originalIndex].isFavorite; 
                        }); 
                      } else if (value == 'delete') { 
                        _deleteNote(originalIndex); 
                      } 
                    }, 
                    itemBuilder: (context) => [
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: Text(
                          'Edit',
                          style: TextStyle(color: c.textPrimary),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'pin',
                        child: Text(
                          note.isPinned ? 'Unpin' : 'Pin',
                          style: TextStyle(color: c.textPrimary),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'favorite',
                        child: Text(
                          note.isFavorite ? 'Remove Favorite' : 'Favorite',
                          style: TextStyle(color: c.textPrimary),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                note.content,
                style: TextStyle(
                  color: c.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: c.textMuted,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _formatDate(note.createdAt),
                    style: TextStyle(
                      color: c.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}