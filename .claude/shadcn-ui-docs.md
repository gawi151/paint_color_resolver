# Shadcn UI for Flutter - Documentation

This documentation was fetched from: https://mariuti.com/flutter-shadcn-ui/llms.txt

> **Note**: This is a reference copy for AI coding agents. For the most up-to-date information, visit the official documentation.

---

# Getting started

Welcome to Shadcn UI for Flutter.
This is the official documentation for Shadcn UI for Flutter.

![Shadcn UI](/flutter-shadcn-ui/shadcn-banner.png)

> The work is still in progress.

:::tip[AI Editor Integration]
If you want to consume the docs in a LLM that accepts markdown, you can use this link:
<https://mariuti.com/flutter-shadcn-ui/llms.txt>
:::

## Installation

Run this command in your terminal from your project root directory:

```bash
flutter pub add shadcn_ui
```

or manually adding to your `pubspec.yaml`:

```diff lang="yaml"
dependencies:
+    shadcn_ui: ^0.2.4 # replace with the latest version
```

## Shadcn (pure)

Use the `ShadApp` widget if you want to use just the ShadcnUI components, without Material or Cupertino.

```diff lang="dart"
+ import 'package:shadcn_ui/shadcn_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
+    return ShadApp();
  }
```

:::tip
If you need to use the `Router` instead of the `Navigator`, use `ShadApp.router`.
:::

## Shadcn + Material

We are the first Flutter UI library to allow shadcn components to be used simultaneously with Material components.
The setup is simple:

```diff lang="dart"
import 'package:shadcn_ui/shadcn_ui.dart';
+ import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
-    return ShadApp();
+    return ShadApp.custom(
+      themeMode: ThemeMode.dark,
+      darkTheme: ShadThemeData(
+        brightness: Brightness.dark,
+        colorScheme: const ShadSlateColorScheme.dark(),
+      ),
+      appBuilder: (context) {
+        return MaterialApp(
+          theme: Theme.of(context),
+          builder: (context, child) {
+            return ShadAppBuilder(child: child!);
+          },
+        );
+      },
+    );
  }
```

:::tip
If you need to use the `Router` instead of the `Navigator`, use `MaterialApp.router`.
:::

---

The default Material `ThemeData` created by `ShadApp` is:

```dart
ThemeData(
  fontFamily: themeData.textTheme.family,
  extensions: themeData.extensions,
  colorScheme: ColorScheme(
    brightness: themeData.brightness,
    primary: themeData.colorScheme.primary,
    onPrimary: themeData.colorScheme.primaryForeground,
    secondary: themeData.colorScheme.secondary,
    onSecondary: themeData.colorScheme.secondaryForeground,
    error: themeData.colorScheme.destructive,
    onError: themeData.colorScheme.destructiveForeground,
    surface: themeData.colorScheme.background,
    onSurface: themeData.colorScheme.foreground,
  ),
  scaffoldBackgroundColor: themeData.colorScheme.background,
  brightness: themeData.brightness,
  dividerTheme: DividerThemeData(
    color: themeData.colorScheme.border,
    thickness: 1,
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: themeData.colorScheme.primary,
    selectionColor: themeData.colorScheme.selection,
    selectionHandleColor: themeData.colorScheme.primary,
  ),
  iconTheme: IconThemeData(
    size: 16,
    color: themeData.colorScheme.foreground,
  ),
  scrollbarTheme: ScrollbarThemeData(
    crossAxisMargin: 1,
    mainAxisMargin: 1,
    thickness: const WidgetStatePropertyAll(8),
    radius: const Radius.circular(999),
    thumbColor: WidgetStatePropertyAll(themeData.colorScheme.border),
  ),
),
```

:::note
Use `Theme.of(context).copyWith(...)` to override the default theme, without losing the default values provided by shadcn_ui.
:::

## Shadcn + Cupertino

If you need to use shadcn components with Cupertino components, use `CupertinoApp` instead of `MaterialApp`, like you are already used to.

```diff lang="dart"
import 'package:shadcn_ui/shadcn_ui.dart';
+ import 'package:flutter/cupertino.dart';
+ import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
-    return ShadApp();
+    return ShadApp.custom(
+      themeMode: ThemeMode.dark,
+      darkTheme: ShadThemeData(
+        brightness: Brightness.dark,
+        colorScheme: const ShadSlateColorScheme.dark(),
+      ),
+      appBuilder: (context) {
+        return CupertinoApp(
+          theme: CupertinoTheme.of(context),
+          localizationsDelegates: const [
+            DefaultMaterialLocalizations.delegate,
+            DefaultCupertinoLocalizations.delegate,
+            DefaultWidgetsLocalizations.delegate,
+          ],
+          builder: (context, child) {
+            return ShadAppBuilder(child: child!);
+          },
+        );
+      },
+    );
  }
```

:::tip
If you need to use the `Router` instead of the `Navigator`, use `CupertinoApp.router`.
:::

---

The default `CupertinoThemeData` created by `ShadApp` is:

```dart
CupertinoThemeData(
  primaryColor: themeData.colorScheme.primary,
  primaryContrastingColor: themeData.colorScheme.primaryForeground,
  scaffoldBackgroundColor: themeData.colorScheme.background,
  barBackgroundColor: themeData.colorScheme.primary,
  brightness: themeData.brightness,
),
```

:::note
Use `CupertinoTheme.of(context).copyWith(...)` to override the default theme, without losing the default values provided by shadcn_ui.
:::


---

# Submit your app

To add your app to the Shadcn UI for Flutter showcase, please go to the [following link](https://github.com/nank1ro/flutter-shadcn-ui/issues/new?template=docs-add-app.yaml) and fill out the form.


---

# Theme Data

Defines the theme and color scheme for the app.

The supported color schemes are:

- blue
- gray
- green
- neutral
- orange
- red
- rose
- slate
- stone
- violet
- yellow
- zinc

## Usage

```diff lang="dart"
import 'package:shadcn_ui/shadcn_ui.dart';

@override
Widget build(BuildContext context) {
  return ShadApp(
+    darkTheme: ShadThemeData(
+      brightness: Brightness.dark,
+      colorScheme: const ShadSlateColorScheme.dark(),
+    ),
    child: ...
  );
}
```

You can override specific properties of the selected theme/color scheme:

```diff lang="dart"
import 'package:shadcn_ui/shadcn_ui.dart';

@override
Widget build(BuildContext context) {
  return ShadApp(
    darkTheme: ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: const ShadSlateColorScheme.dark(
+          background: Colors.blue,
        ),
+        primaryButtonTheme: const ShadButtonTheme(
+          backgroundColor: Colors.cyan,
+        ),
      ),
    ),
    child: ...
  );
}
```

:::tip
You can also create your custom color scheme, just extend the `ShadColorScheme` class and pass all the properties.
:::

## ShadColorScheme.fromName

If you want to allow the user to change the default shadcn themes, I suggest using `ShadColorScheme.fromName`.

```dart
// available color scheme names
final shadThemeColors = [
  'blue',
  'gray',
  'green',
  'neutral',
  'orange',
  'red',
  'rose',
  'slate',
  'stone',
  'violet',
  'yellow',
  'zinc',
];

final lightColorScheme = ShadColorScheme.fromName('blue');
final darkColorScheme = ShadColorScheme.fromName('slate', brightness: Brightness.dark);
```

In this way you can easily create a select to change the color scheme, for example:

```dart
import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

// Somewhere in your app
ShadSelect<String>(
  initialValue: 'slate',
  maxHeight: 200,
  options: shadThemeColors.map(
    (option) => ShadOption(
      value: option,
      child: Text(
        option.capitalizeFirst(),
      ),
    ),
  ),
  selectedOptionBuilder: (context, value) {
    return Text(value.capitalizeFirst());
  },
  onChanged: (value) {
    // rebuild the app using your state management solution
  },
),
```

For example I'm using solidart as state management, here it is the example code used to rebuild the app widget when the user changes the theme mode. Check the "Toggle Theme" example at <https://solidart.mariuti.com/examples>

The same can be done for the color scheme, using a `Signal<String>()`

## Extend with custom colors

You can extend the `ShadColorScheme` with your own custom colors by using the `custom` parameter.
```diff lang="dart"
return ShadApp(
  theme: ShadThemeData(
+    colorScheme: const ShadZincColorScheme.light(
+      custom: {
+        'myCustomColor': Color.fromARGB(255, 177, 4, 196),
+      },
+    ),
  ),
);
```

Then you can access it like this `ShadTheme.of(context).colorScheme.custom['myCustomColor']!`.

Or you can create an extension on `ShadColorScheme` to make it easier to access:
```dart
extension CustomColorExtension on ShadColorScheme {
  Color get myCustomColor => custom['myCustomColor']!;
}
```

In this way you can access it like other colors `ShadTheme.of(context).colorScheme.myCustomColor`.



---

# Packages

## Packages included in the library

Flutter Shadcn UI consists of fantastic open-source libraries that are exported and you can use them without importing them into your project.

### [flutter_animate](https://pub.dev/packages/flutter_animate)

The flutter animate library is a very cool animations library extensively used in Shadcn UI Components.

With flutter_animate animations can be easily customized from the user, because components will take a `List<Effect>`.

### [lucide_icons_flutter](https://pub.dev/packages/lucide_icons_flutter)

A nice icon library that is used in Shadcn UI Components.
You can use Lucide icons with the `LucideIcons` class, for example `LucideIcons.activity`.

You can browse all the icons [here](https://lucide.dev/icons/).

### [two_dimensional_scrollables](https://pub.dev/packages/two_dimensional_scrollables)

A nice raw table (very performant) implementation used by the [ShadTable](../components/table) component.

### [intl](https://pub.dev/packages/intl)

The intl package provides internationalization and localization facilities, including message translation.

### [universal_image](https://pub.dev/packages/universal_image)

Support multiple image formats. Used by the [ShadAvatar](../components/avatar) component.


---

# Typography


Styles for headings, paragraphs, lists...etc

## h1Large

 ```dart
Text(
  'Taxing Laughter: The Joke Tax Chronicles',
  style: ShadTheme.of(context).textTheme.h1Large,
)
```

## h1

 ```dart
Text(
  'Taxing Laughter: The Joke Tax Chronicles',
  style: ShadTheme.of(context).textTheme.h1,
)
```

## h2

 ```dart
Text(
  'The People of the Kingdom',
  style: ShadTheme.of(context).textTheme.h2,
)
```

## h3

 ```dart
Text(
  'The Joke Tax',
  style: ShadTheme.of(context).textTheme.h3,
)
```

## h4

 ```dart
Text(
  'The king, seeing how much happier his subjects were, realized the error of his ways and repealed the joke tax.',
  style: ShadTheme.of(context).textTheme.h4,
)
```

## p

 ```dart
Text(
  'The king, seeing how much happier his subjects were, realized the error of his ways and repealed the joke tax.',
  style: ShadTheme.of(context).textTheme.p,
)
```

## Blockquote

 ```dart
Text(
  '"After all," he said, "everyone enjoys a good joke, so it\'s only fair that they should pay for the privilege."',
  style: ShadTheme.of(context).textTheme.blockquote,
)
```

## Table

 ```dart
Text(
  "King's Treasury",
  style: ShadTheme.of(context).textTheme.table,
)
```

## List

 ```dart
Text(
  '1st level of puns: 5 gold coins',
  style: ShadTheme.of(context).textTheme.list,
)
```

## Lead

 ```dart
Text(
  'A modal dialog that interrupts the user with important content and expects a response.',
  style: ShadTheme.of(context).textTheme.lead,
)
```

## Large

 ```dart
Text(
  'Are you absolutely sure?',
  style: ShadTheme.of(context).textTheme.large,
)
```

## Small

 ```dart
Text(
  'Email address',
  style: ShadTheme.of(context).textTheme.small,
)
```

## Muted

 ```dart
Text(
  'Enter your email address.',
  style: ShadTheme.of(context).textTheme.muted,
)
```

## Custom font family

By default Shadcn UI uses [Geist](https://vercel.com/font) as default font family.
To change it, add the local font to your project, for example in the `/fonts` directory.
Then update your `pubspec.yaml` with something like this:

```diff lang="yaml"
flutter:
+  fonts:
+    - family: UbuntuMono
+      fonts:
+        - asset: fonts/UbuntuMono-Regular.ttf
+        - asset: fonts/UbuntuMono-Italic.ttf
+          style: italic
+        - asset: fonts/UbuntuMono-Bold.ttf
+          weight: 700
+        - asset: fonts/UbuntuMono-BoldItalic.ttf
+          weight: 700
+          style: italic
```

Then in your `ShadApp` update the `ShadTextTheme`:
```diff lang="dart"
return ShadApp(
  debugShowCheckedModeBanner: false,
  themeMode: themeMode,
  routes: routes,
  theme: ShadThemeData(
    brightness: Brightness.light,
    colorScheme: const ShadZincColorScheme.light(),
+    textTheme: ShadTextTheme(
+      colorScheme: const ShadZincColorScheme.light(),
+      family: 'UbuntuMono',
+    ),
  ),
  ...
);
```

## Google font

Install the [google_fonts](https://pub.dev/packages/google_fonts) package.
Then add the google font to your `ShadApp`:
```diff lang="dart"
return ShadApp(
  debugShowCheckedModeBanner: false,
  themeMode: themeMode,
  routes: routes,
  theme: ShadThemeData(
    brightness: Brightness.light,
    colorScheme: const ShadZincColorScheme.light(),
+    textTheme: ShadTextTheme.fromGoogleFont(GoogleFonts.poppins),
  ),
  ...
);
```

## Extend with custom styles

You can extend the `ShadTextTheme` with your own custom styles by using the `custom` parameter.
```diff lang="dart"
return ShadApp(
  theme: ShadThemeData(
+    textTheme: ShadTextTheme(
+      custom: {
+        'myCustomStyle': const TextStyle(
+          fontSize: 16,
+          fontWeight: FontWeight.w400,
+          color: Colors.blue,
+        ),
+      },
+    ),
  ),
);
```

Then you can access it like this `ShadTheme.of(context).textTheme.custom['myCustomStyle']!`.

Or you can create an extension on `ShadTextTheme` to make it easier to access:
```dart
extension CustomStyleExtension on ShadTextTheme {
  TextStyle get myCustomStyle => custom['myCustomStyle']!;
}
```

In this way you can access it like other styles `ShadTheme.of(context).textTheme.myCustomStyle`.


---

# Component Examples

## Accordion

A vertically stacked set of interactive headings that each reveal a section of content.

```dart
final details = [
  (
    title: 'Is it acceptable?',
    content: 'Yes. It adheres to the WAI-ARIA design pattern.',
  ),
  (
    title: 'Is it styled?',
    content:
        "Yes. It comes with default styles that matches the other components' aesthetic.",
  ),
  (
    title: 'Is it animated?',
    content:
        "Yes. It's animated by default, but you can disable it if you prefer.",
  ),
];

@override
Widget build(BuildContext context) {
  return ShadAccordion<({String content, String title})>(
    children: details.map(
      (detail) => ShadAccordionItem(
        value: detail,
        title: Text(detail.title),
        child: Text(detail.content),
      ),
    ),
  );
}
```

### Multiple

```dart
ShadAccordion<({String content, String title})>.multiple(
  children: details.map(
    (detail) => ShadAccordionItem(
      value: detail,
      title: Text(detail.title),
      child: Text(detail.content),
    ),
  ),
);
```

## Alert

Displays a callout for user attention.

```dart
ShadAlert(
  icon: Icon(LucideIcons.terminal),
  title: Text('Heads up!'),
  description: Text('You can add components to your app using the cli.'),
),
```

### Destructive

```dart
ShadAlert.destructive(
  icon: Icon(LucideIcons.circleAlert),
  title: Text('Error'),
  description: Text('Your session has expired. Please log in again.'),
)
```

## Avatar

An image element with a placeholder for representing the user.

```dart
ShadAvatar(
  'https://app.requestly.io/delay/2000/avatars.githubusercontent.com/u/124599?v=4',
  placeholder: Text('CN'),
)
```

## Badge

Displays a badge or a component that looks like a badge.

```dart
ShadBadge(child: const Text('Primary'))
ShadBadge.secondary(child: const Text('Secondary'))
ShadBadge.destructive(child: const Text('Destructive'))
ShadBadge.outline(child: const Text('Outline'))
```

## Breadcrumb

Displays the path to the current resource using a hierarchy of links.

```dart
ShadBreadcrumb(
  children: [
    ShadBreadcrumbLink(
      onPressed: () => print('Navigating to Home'),
      child: const Text('Home'),
    ),
    ShadBreadcrumbDropdown(
      items: [
        ShadBreadcrumbDropMenuItem(
          onPressed: () => print('Navigating to Documentation'),
          child: const Text('Documentation'),
        ),
      ],
      showDropdownArrow: false,
      child: ShadBreadcrumbEllipsis(),
    ),
    Text('Components'),
    Text('Breadcrumb'),
  ],
);
```

## Button

Displays a button or a component that looks like a button.

```dart
ShadButton(child: const Text('Primary'), onPressed: () {})
ShadButton.secondary(child: const Text('Secondary'), onPressed: () {})
ShadButton.destructive(child: const Text('Destructive'), onPressed: () {})
ShadButton.outline(child: const Text('Outline'), onPressed: () {})
ShadButton.ghost(child: const Text('Ghost'), onPressed: () {})
ShadButton.link(child: const Text('Link'), onPressed: () {})
```

### With Icon

```dart
ShadButton(
  onPressed: () {},
  leading: const Icon(LucideIcons.mail),
  child: const Text('Login with Email'),
)
```

## Calendar

A date field component that allows users to enter and edit date.

```dart
ShadCalendar(
  selected: DateTime.now(),
  fromMonth: DateTime(DateTime.now().year - 1),
  toMonth: DateTime(DateTime.now().year, 12),
)
```

### Range

```dart
ShadCalendar.range(min: 2, max: 5)
```

### Multiple

```dart
ShadCalendar.multiple(
  numberOfMonths: 2,
  min: 5,
  max: 10,
)
```

## Card

Displays a card with header, content, and footer.

```dart
ShadCard(
  width: 350,
  title: Text('Card Title'),
  description: const Text('Card description'),
  footer: ShadButton(child: const Text('Action')),
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Text('Card content'),
  ),
)
```

## Checkbox

A control that allows the user to toggle between checked and not checked.

```dart
ShadCheckbox(
  value: value,
  onChanged: (v) => setState(() => value = v),
  label: const Text('Accept terms and conditions'),
  sublabel: const Text('You agree to our Terms of Service and Privacy Policy.'),
)
```

### Form Field

```dart
ShadCheckboxFormField(
  id: 'terms',
  initialValue: false,
  inputLabel: const Text('I accept the terms and conditions'),
  onChanged: (v) {},
  validator: (v) {
    if (!v) return 'You must accept the terms and conditions';
    return null;
  },
)
```

## Context Menu

Displays a menu to the user — triggered by a mouse right-click.

```dart
ShadContextMenuRegion(
  constraints: const BoxConstraints(minWidth: 300),
  items: [
    const ShadContextMenuItem.inset(child: Text('Back')),
    const ShadContextMenuItem.inset(enabled: false, child: Text('Forward')),
    const Divider(height: 8),
    const ShadContextMenuItem(
      leading: Icon(LucideIcons.check),
      child: Text('Show Bookmarks Bar'),
    ),
  ],
  child: Container(
    width: 300,
    height: 200,
    alignment: Alignment.center,
    child: const Text('Right click here'),
  ),
)
```

## Date Picker

A date picker component with range and presets.

```dart
ShadDatePicker()
ShadDatePicker.range()
```

### Form Field

```dart
ShadDatePickerFormField(
  label: const Text('Date of birth'),
  onChanged: print,
  validator: (v) {
    if (v == null) return 'A date of birth is required.';
    return null;
  },
)
```

## Dialog

A modal dialog that interrupts the user.

```dart
showShadDialog(
  context: context,
  builder: (context) => ShadDialog(
    title: const Text('Edit Profile'),
    description: const Text('Make changes to your profile here'),
    actions: const [ShadButton(child: Text('Save changes'))],
    child: // Your content
  ),
);
```

### Alert Dialog

```dart
showShadDialog(
  context: context,
  builder: (context) => ShadDialog.alert(
    title: const Text('Are you absolutely sure?'),
    description: const Text('This action cannot be undone.'),
    actions: [
      ShadButton.outline(
        child: const Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(false),
      ),
      ShadButton(
        child: const Text('Continue'),
        onPressed: () => Navigator.of(context).pop(true),
      ),
    ],
  ),
);
```

## Form

Builds a form with validation and easy access to form fields values.

```dart
final formKey = GlobalKey<ShadFormState>();

ShadForm(
  key: formKey,
  child: Column(
    children: [
      ShadInputFormField(
        id: 'username',
        label: const Text('Username'),
        validator: (v) {
          if (v.length < 2) return 'Username must be at least 2 characters.';
          return null;
        },
      ),
      ShadButton(
        child: const Text('Submit'),
        onPressed: () {
          if (formKey.currentState!.saveAndValidate()) {
            print('validation succeeded with ${formKey.currentState!.value}');
          }
        },
      ),
    ],
  ),
)
```

## Input

A text input field.

```dart
ShadInput(
  placeholder: const Text('Email'),
  keyboardType: TextInputType.emailAddress,
)
```

### Form Field

```dart
ShadInputFormField(
  id: 'email',
  label: const Text('Email'),
  placeholder: const Text('email@example.com'),
  validator: (v) {
    if (!v.contains('@')) return 'Invalid email';
    return null;
  },
)
```

## Popover

Displays rich content in a portal, triggered by a button.

```dart
ShadPopover(
  popover: (context) => Container(
    width: 200,
    padding: const EdgeInsets.all(12),
    child: const Text('Popover content'),
  ),
  child: const ShadButton(child: Text('Open')),
)
```

## Radio Group

A set of checkable buttons where only one can be checked at a time.

```dart
ShadRadioGroup<String>(
  initialValue: 'default',
  onChanged: (value) {},
  items: const [
    ShadRadio(value: 'default', label: Text('Default')),
    ShadRadio(value: 'comfortable', label: Text('Comfortable')),
    ShadRadio(value: 'compact', label: Text('Compact')),
  ],
)
```

## Select

Displays a list of options for the user to pick from.

```dart
ShadSelect<String>(
  placeholder: const Text('Select a fruit'),
  options: [
    ShadOption(value: 'apple', child: Text('Apple')),
    ShadOption(value: 'banana', child: Text('Banana')),
    ShadOption(value: 'orange', child: Text('Orange')),
  ],
  selectedOptionBuilder: (context, value) => Text(value),
  onChanged: (value) {},
)
```

### Form Field

```dart
ShadSelectFormField<String>(
  id: 'framework',
  label: const Text('Framework'),
  placeholder: const Text('Select'),
  options: frameworks.entries
      .map((e) => ShadOption(value: e.key, child: Text(e.value)))
      .toList(),
  selectedOptionBuilder: (context, value) => Text(frameworks[value]!),
  validator: (v) {
    if (v == null) return 'Please select a framework';
    return null;
  },
)
```

## Slider

An input where the user selects a value from within a given range.

```dart
ShadSlider(
  value: [50],
  onChanged: (value) {},
  min: 0,
  max: 100,
)
```

## Switch

A control that allows the user to toggle between checked and not checked.

```dart
ShadSwitch(
  value: value,
  onChanged: (v) => setState(() => value = v),
  label: const Text('Airplane Mode'),
)
```

### Form Field

```dart
ShadSwitchFormField(
  id: 'marketing',
  initialValue: false,
  inputLabel: const Text('Marketing emails'),
  inputSublabel: const Text('Receive emails about new products'),
)
```

## Table

A responsive table component.

```dart
ShadTable(
  columnCount: 3,
  rowCount: 10,
  columnBuilder: (context, index) => // Column header
  cellBuilder: (context, row, col) => // Cell content
)
```

## Tabs

A set of layered sections of content—known as tab panels.

```dart
ShadTabs<String>(
  value: 'account',
  tabBarConstraints: const BoxConstraints(maxWidth: 400),
  contentConstraints: const BoxConstraints(maxWidth: 400),
  tabs: [
    ShadTab(
      value: 'account',
      text: const Text('Account'),
      content: // Your content
    ),
    ShadTab(
      value: 'password',
      text: const Text('Password'),
      content: // Your content
    ),
  ],
)
```

## Toast

A succinct message that is displayed temporarily.

```dart
ShadToaster.of(context).show(
  ShadToast(
    title: const Text('Scheduled: Catch up'),
    description: const Text('Friday, February 10, 2023 at 5:57 PM'),
  ),
);
```

### Destructive

```dart
ShadToaster.of(context).show(
  ShadToast.destructive(
    title: const Text('Uh oh! Something went wrong'),
    description: const Text('There was a problem with your request.'),
  ),
);
```

## Tooltip

A popup that displays information related to an element.

```dart
ShadTooltip(
  builder: (context) => const Text('Add to library'),
  child: ShadButton.outline(
    width: 40,
    height: 40,
    padding: EdgeInsets.zero,
    icon: const Icon(LucideIcons.plus),
    onPressed: () {},
  ),
)
```

---

# Best Practices for Paint Color Resolver

## Component Usage

1. **Always use const constructors** where possible
2. **Access theme via ShadTheme.of(context)** instead of hardcoding values
3. **Use LucideIcons** for all icons
4. **Prefer shadcn_ui components** over Material widgets

## Theme Access

```dart
final theme = ShadTheme.of(context);
final colorScheme = theme.colorScheme;
final textTheme = theme.textTheme;
```

## Common Patterns

### Form with Validation
```dart
final formKey = GlobalKey<ShadFormState>();

ShadForm(
  key: formKey,
  child: Column(
    children: [
      ShadInputFormField(id: 'field', validator: (v) => ...),
      ShadButton(
        onPressed: () {
          if (formKey.currentState!.saveAndValidate()) {
            // Use formKey.currentState!.value
          }
        },
      ),
    ],
  ),
)
```

### Dialogs
```dart
await showShadDialog<bool>(
  context: context,
  builder: (context) => ShadDialog.alert(
    title: const Text('Confirm'),
    actions: [
      ShadButton.outline(
        child: const Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(false),
      ),
      ShadButton(
        child: const Text('Confirm'),
        onPressed: () => Navigator.of(context).pop(true),
      ),
    ],
  ),
);
```

### Toasts
```dart
ShadToaster.of(context).show(
  ShadToast(
    title: const Text('Success'),
    description: const Text('Operation completed'),
  ),
);
```

---

**Last Updated**: February 13, 2026 (from llms.txt snapshot)
