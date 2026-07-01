
 
import 'package:flutter/material.dart'; 
 
enum AppThemeMode { 
  dark, 
  light, 
} 
 
class AppColors { 
  final Color background; 
  final Color surface; 
  final Color surfaceSoft; 
  final Color headerStart; 
  final Color headerEnd; 
  final Color primary; 
  final Color secondary; 
  final Color success; 
  final Color warning; 
  final Color danger; 
  final Color textPrimary; 
  final Color textSecondary; 
  final Color textMuted; 
  final Color border; 
  final Color shadow; 
  final Color tileBlue1; 
  final Color tileBlue2; 
  final Color tileCyan1; 
  final Color tileCyan2; 
  final Color tileGreen1; 
  final Color tileGreen2; 
  final Color tilePurple1; 
  final Color tilePurple2; 
  final Color tileOrange1; 
  final Color tileOrange2; 
  final Color tilePink1; 
  final Color tilePink2; 
 
  const AppColors({ 
    required this.background, 
    required this.surface, 
    required this.surfaceSoft, 
    required this.headerStart, 
    required this.headerEnd, 
    required this.primary, 
    required this.secondary, 
    required this.success, 
    required this.warning, 
    required this.danger, 
    required this.textPrimary, 
    required this.textSecondary, 
    required this.textMuted, 
    required this.border, 
    required this.shadow, 
    required this.tileBlue1, 
    required this.tileBlue2, 
    required this.tileCyan1, 
    required this.tileCyan2, 
    required this.tileGreen1, 
    required this.tileGreen2, 
    required this.tilePurple1, 
    required this.tilePurple2, 
    required this.tileOrange1, 
    required this.tileOrange2, 
    required this.tilePink1, 
    required this.tilePink2, 
  }); 
} 
 
class AppThemeController extends ChangeNotifier { 
  AppThemeMode _mode = AppThemeMode.dark; 
 
  AppThemeMode get mode => _mode; 
 
  bool get isDark => _mode == AppThemeMode.dark; 
 
  void setMode(AppThemeMode newMode) { 
    _mode = newMode; 
    notifyListeners(); 
  } 
 
  AppColors get colors { 
    if (isDark) { 
      return const AppColors( 
        background: Color(0xFF050B18), 
        surface: Color(0xFF0B1A3A), 
        surfaceSoft: Color(0xFF132755), 
        headerStart: Color(0xFF0C1F4F), 
        headerEnd: Color(0xFF1F4FAE), 
        primary: Color(0xFF2F67EA), 
        secondary: Color(0xFF56A5FF), 
        success: Color(0xFF19C37D), 
        warning: Color(0xFFFFB020), 
        danger: Color(0xFFFF5A5F), 
        textPrimary: Color(0xFFF8FAFC), 
        textSecondary: Color(0xFFB8C2D9), 
        textMuted: Color(0xFF8B97B2), 
        border: Color(0x22FFFFFF), 
        shadow: Color(0x66000000), 
        tileBlue1: Color(0xFF246BFD), 
        tileBlue2: Color(0xFF2649D8), 
        tileCyan1: Color(0xFF19A7F2), 
        tileCyan2: Color(0xFF117AD5), 
        tileGreen1: Color(0xFF14C784), 
        tileGreen2: Color(0xFF0F9F68), 
        tilePurple1: Color(0xFF7F4BFF), 
        tilePurple2: Color(0xFF5E2EDB), 
        tileOrange1: Color(0xFFFFA726), 
        tileOrange2: Color(0xFFF57C00), 
        tilePink1: Color(0xFFFF4FB3), 
        tilePink2: Color(0xFFE12D8D), 
      ); 
    } else { 
      return const AppColors( 
        background: Color(0xFFF3F7FD), 
        surface: Colors.white, 
        surfaceSoft: Color(0xFFF0F4FC), 
        headerStart: Color(0xFF295FD8), 
        headerEnd: Color(0xFF4A8DFF), 
        primary: Color(0xFF2F67EA), 
        secondary: Color(0xFF56A5FF), 
        success: Color(0xFF19C37D), 
        warning: Color(0xFFFFB020), 
        danger: Color(0xFFFF5A5F), 
        textPrimary: Color(0xFF101828), 
        textSecondary: Color(0xFF475467), 
        textMuted: Color(0xFF667085), 
        border: Color(0x14000000), 
        shadow: Color(0x140F172A), 
        tileBlue1: Color(0xFF4D84FF), 
        tileBlue2: Color(0xFF2F67EA), 
        tileCyan1: Color(0xFF33B8F5), 
        tileCyan2: Color(0xFF1692E0), 
        tileGreen1: Color(0xFF2AD39A), 
        tileGreen2: Color(0xFF14B97F), 
        tilePurple1: Color(0xFF9A73FF), 
        tilePurple2: Color(0xFF7A48EC), 
        tileOrange1: Color(0xFFFFB84D), 
        tileOrange2: Color(0xFFFF9800), 
        tilePink1: Color(0xFFFF6BC0), 
        tilePink2: Color(0xFFEA4A9E), 
      ); 
    } 
  } 
 
  ThemeData get materialTheme { 
    final c = colors; 
 
    return ThemeData( 
      brightness: isDark ? Brightness.dark : Brightness.light, 
      scaffoldBackgroundColor: c.background, 
      fontFamily: 'Roboto', 
      appBarTheme: AppBarTheme( 
        backgroundColor: c.surface, 
        foregroundColor: c.textPrimary, 
        elevation: 0, 
        centerTitle: false, 
      ), 
      colorScheme: isDark 
          ? ColorScheme.dark( 
              primary: c.primary, 
              secondary: c.secondary, 
              surface: c.surface, 
            ) 
          : ColorScheme.light( 
              primary: c.primary, 
              secondary: c.secondary, 
              surface: c.surface, 
            ), 
      cardColor: c.surface, 
      dividerColor: c.border, 
      switchTheme: SwitchThemeData( 
        thumbColor: WidgetStateProperty.resolveWith((states) { 
          return states.contains(WidgetState.selected) 
              ? c.primary 
              : c.textMuted; 
        }), 
        trackColor: WidgetStateProperty.resolveWith((states) { 
          return states.contains(WidgetState.selected) 
              ? c.primary.withOpacity(0.35) 
              : c.surfaceSoft; 
        }), 
      ), 
    ); 
  } 
} 
 
class ThemeScope extends InheritedNotifier<AppThemeController> { 
  const ThemeScope({ 
    super.key, 
    required AppThemeController controller, 
    required super.child, 
}) : super(notifier: controller); 
static AppThemeController of(BuildContext context) { 
final ThemeScope? scope = 
context.dependOnInheritedWidgetOfExactType<ThemeScope>(); 
assert(scope != null, 'ThemeScope not found'); 
return scope!.notifier!; 
} 
} 