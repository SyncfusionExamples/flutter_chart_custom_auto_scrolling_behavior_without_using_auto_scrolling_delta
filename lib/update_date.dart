// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import '../custom_widgets/single_selection_date_picker.dart';

// class UpdateBirthday extends StatefulWidget {
//   const UpdateBirthday({super.key});

//   @override
//   State<UpdateBirthday> createState() => _UpdateBirthdayState();
// }

// class _UpdateBirthdayState extends State<UpdateBirthday> {
//   DateTime? _selectedDate;
//   final TextEditingController _dateController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _initializeSelectedDate();
//   }

//   @override
//   void dispose() {
//     _dateController.dispose();
//     super.dispose();
//   }

//   void _initializeSelectedDate() {
//     _selectedDate = DateTime.now();
//     _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       scrollable: true,
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       title: _buildDialogTitle(context),
//       content: _buildContent(context),
//       actions: _buildDialogActions(context),
//     );
//   }

//   SizedBox _buildDialogTitle(BuildContext context) {
//     return SizedBox(
//       width: MediaQuery.of(context).size.width * 0.22,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             'Update Birthday',
//             style: TextStyle(
//               fontFamily: 'Roboto',
//               fontWeight: FontWeight.w400,
//               fontSize: 24,
//               color: Theme.of(context).colorScheme.onSurface,
//             ),
//           ),
//           IconButton(
//             iconSize: 24,
//             alignment: Alignment.center,
//             color: Theme.of(context).colorScheme.onSurfaceVariant,
//             icon: const Icon(Icons.close),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//         ],
//       ),
//     );
//   }

//   SizedBox _buildContent(BuildContext context) {
//     return SizedBox(
//       width: MediaQuery.of(context).size.width * 0.22,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(3),
//             decoration: BoxDecoration(
//               border: Border.all(color: Theme.of(context).colorScheme.outline),
//               borderRadius: BorderRadius.circular(4),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextFormField(
//                     controller: _dateController,
//                     decoration: const InputDecoration(
//                       hintText: 'dd/MM/yyyy',
//                       border: InputBorder.none,
//                     ),
//                     keyboardType: TextInputType.datetime,
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     showSingleDatePickerDialog(
//                       context,
//                       onSingleDateSelected: (String selectedDate) {
//                         setState(() {
//                           _dateController.text = selectedDate;
//                         });
//                       },
//                     );
//                   },
//                   icon: Image.asset(
//                     'assets/date_picker.png',
//                     width: 18,
//                     height: 18,
//                     color: Theme.of(context).colorScheme.onSurfaceVariant,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   List<Widget> _buildDialogActions(BuildContext context) {
//     return [
//       TextButton(
//         onPressed: () => Navigator.of(context).pop(),
//         child: Text(
//           'Cancel',
//           style: TextStyle(
//             fontFamily: 'Roboto',
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Theme.of(context).colorScheme.primary,
//           ),
//         ),
//       ),
//       const SizedBox(width: 10),
//       SizedBox(
//         width: 80,
//         height: 45,
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Theme.of(context).colorScheme.primary,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(25),
//             ),
//           ),
//           onPressed:
//               _selectedDate != null ? () => Navigator.of(context).pop() : null,
//           child: Text(
//             'Save',
//             style: TextStyle(
//               fontFamily: 'Roboto',
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: Theme.of(context).colorScheme.onPrimary,
//             ),
//           ),
//         ),
//       ),
//     ];
//   }
// }