
 
import 'package:flutter/material.dart'; 
 
class AppDialogs { 
  static Future<bool> confirmAction({ 
    required BuildContext context, 
    required String title, 
    required String message, 
    String confirmText = 'Confirm', 
    String cancelText = 'Cancel', 
    Color? confirmColor, 
  }) async { 
    final result = await showDialog<bool>( 
      context: context, 
      builder: (context) { 
        final theme = Theme.of(context); 
        return AlertDialog( 
          shape: RoundedRectangleBorder( 
            borderRadius: BorderRadius.circular(18), 
          ), 
          title: Text(title), 
          content: Text(message), 
          actions: [ 
            TextButton( 
              onPressed: () => Navigator.pop(context, false), 
              child: Text(cancelText), 
            ), 
            ElevatedButton( 
              style: ElevatedButton.styleFrom( 
                backgroundColor: confirmColor ?? theme.colorScheme.primary, 
                foregroundColor: theme.colorScheme.onPrimary, 
              ), 
              onPressed: () => Navigator.pop(context, true), 
              child: Text(confirmText), 
            ), 
          ], 
        ); 
      }, 
    ); 
    return result ?? false; 
  } 
 
  static Future<bool> confirmDeleteMessage(BuildContext context) { 
    return confirmAction( 
      context: context, 
      title: 'Delete message?', 
      message: 'This message will be removed from this demo chat.', 
      confirmText: 'Delete', 
      confirmColor: Colors.red, 
    ); 
  } 
 
  static Future<bool> confirmClearChat( 
    BuildContext context, { 
    required String title, 
  }) { 
    return confirmAction( 
      context: context, 
      title: 'Clear chat?', 
      message: 'All visible messages in "$title" will be removed.', 
      confirmText: 'Clear', 
      confirmColor: Colors.red, 
    ); 
  } 
 
  static Future<bool> confirmAttachmentSend( 
    BuildContext context, { 
    required String itemLabel, 
  }) { 
    return confirmAction( 
      context: context, 
      title: 'Send attachment?', 
      message: 'Do you want to send this $itemLabel now?', 
      confirmText: 'Send', 
    ); 
  } 
 
  static void showSnack( 
    BuildContext context, 
    String message, 
  ) { 
    ScaffoldMessenger.of(context).hideCurrentSnackBar(); 
    ScaffoldMessenger.of(context).showSnackBar( 
      SnackBar(content: Text(message)), 
    ); 
  } 
} 
 