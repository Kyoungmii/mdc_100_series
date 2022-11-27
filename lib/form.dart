import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class CompleteForm extends StatefulWidget {
  const CompleteForm({Key? key}) : super(key: key);

  @override
  State<CompleteForm> createState() {
    return _CompleteFormState();
  }
}

class _CompleteFormState extends State<CompleteForm> {
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final _formKey = GlobalKey<FormBuilderState>();
  bool _ageHasError = false;
  bool _genderHasError = false;

  var genderOptions = ['Male', 'Female', 'Other'];

  void _onChanged(dynamic val) => debugPrint(val.toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Builder Example')),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FormBuilder(
                key: _formKey,
                // enabled: false,
                onChanged: () {
                  _formKey.currentState!.save();
                  debugPrint(_formKey.currentState!.value.toString());
                },
                autovalidateMode: AutovalidateMode.disabled,
                initialValue: const {
                  'movie_rating': 5,
                  'best_drink': 'None',
                  'age': '20',
                  'gender': 'Male',
                  'illness_filter': ['None']
                },
                skipDisabled: true,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 15),
                    FormBuilderDateTimePicker(
                      name: 'date',
                      initialEntryMode: DatePickerEntryMode.calendar,
                      initialValue: DateTime.now(),
                      inputType: InputType.both,
                      decoration: InputDecoration(
                        labelText: 'Appointment Time',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _formKey.currentState!.fields['date']
                                ?.didChange(null);
                          },
                        ),
                      ),
                      initialTime: const TimeOfDay(hour: 8, minute: 0),
                      // locale: const Locale.fromSubtags(languageCode: 'fr'),
                    ),
                    FormBuilderDateRangePicker(
                      name: 'date_range',
                      firstDate: DateTime(1970),
                      lastDate: DateTime(2030),
                      format: DateFormat('yyyy-MM-dd'),
                      onChanged: _onChanged,
                      decoration: InputDecoration(
                        labelText: 'Date Range',
                        helperText: 'Helper text',
                        hintText: 'Hint text',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _formKey.currentState!.fields['date_range']
                                ?.didChange(null);
                          },
                        ),
                      ),
                    ),
                    FormBuilderSlider(
                      name: 'slider',
                      // validator: FormBuilderValidators.compose([
                      //   FormBuilderValidators.min(6),
                      // ]),
                      onChanged: _onChanged,
                      min: 0.0,
                      max: 10.0,
                      initialValue: 7.0,
                      divisions: 20,
                      activeColor: Colors.red,
                      inactiveColor: Colors.pink[100],
                      decoration: const InputDecoration(
                        labelText: 'The proper price of vitamin(10000₩)',
                      ),
                    ),
                    // FormBuilderRangeSlider(
                    //   name: 'range_slider',
                    //   // validator: FormBuilderValidators.compose([FormBuilderValidators.min(context, 6)]),
                    //   onChanged: _onChanged,
                    //   min: 0.0,
                    //   max: 100.0,
                    //   initialValue: const RangeValues(4, 7),
                    //   divisions: 20,
                    //   activeColor: Colors.red,
                    //   inactiveColor: Colors.pink[100],
                    //   decoration:
                    //   const InputDecoration(labelText: 'The proper price of vitamin(₩)'),
                    // ),
                    FormBuilderCheckbox(
                      name: 'accept_terms',
                      initialValue: false,
                      onChanged: _onChanged,
                      title: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'I have read and agree to the ',
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: 'Terms and Conditions',
                              style: TextStyle(color: Colors.blue),
                              // Flutter doesn't allow a button inside a button
                              // https://github.com/flutter/flutter/issues/31437#issuecomment-492411086
                              /*
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  print('launch url');
                                },
                              */
                            ),
                          ],
                        ),
                      ),
                      // validator: FormBuilderValidators.equal(
                      //   true,
                      //   errorText:
                      //   'You must accept terms and conditions to continue',
                      // ),
                    ),
                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.always,
                      name: 'age',
                      decoration: InputDecoration(
                        labelText: 'Age',
                        suffixIcon: _ageHasError
                            ? const Icon(Icons.error, color: Colors.red)
                            : const Icon(Icons.check, color: Colors.green),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _ageHasError = !(_formKey.currentState?.fields['age']
                              ?.validate() ??
                              false);
                        });
                      },
                      // valueTransformer: (text) => num.tryParse(text),
                      // validator: FormBuilderValidators.compose([
                      //   FormBuilderValidators.required(),
                      //   FormBuilderValidators.numeric(),
                      //   FormBuilderValidators.max(70),
                      // ]),
                      // initialValue: '12',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    FormBuilderDropdown<String>(
                      // autovalidate: true,
                      name: 'gender',
                      decoration: InputDecoration(
                        labelText: 'Gender',
                        suffix: _genderHasError
                            ? const Icon(Icons.error)
                            : const Icon(Icons.check),
                        hintText: 'Select Gender',
                      ),
                      // validator: FormBuilderValidators.compose(
                      //     [FormBuilderValidators.required()]),
                      items: genderOptions
                          .map((gender) => DropdownMenuItem(
                        alignment: AlignmentDirectional.center,
                        value: gender,
                        child: Text(gender),
                      ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          _genderHasError = !(_formKey
                              .currentState?.fields['gender']
                              ?.validate() ??
                              false);
                        });
                      },
                      valueTransformer: (val) => val?.toString(),
                    ),
                    FormBuilderRadioGroup<String>(
                      decoration: const InputDecoration(
                        labelText: 'How many times a week do you drink(alcohol)?',
                      ),
                      initialValue: null,
                      name: 'best_drink',
                      onChanged: _onChanged,
                      // validator: FormBuilderValidators.compose(
                      //     [FormBuilderValidators.required()]),
                      options:
                      ['None', 'Once', 'Twice', 'Three times', 'More than four']
                          .map((lang) => FormBuilderFieldOption(
                        value: lang,
                        child: Text(lang),
                      ))
                          .toList(growable: false),
                      controlAffinity: ControlAffinity.trailing,
                    ),
                    FormBuilderRadioGroup<String>(
                      decoration: const InputDecoration(
                        labelText: 'How many cigarettes do you smoke a day?',
                      ),
                      initialValue: null,
                      name: 'best_smoke',
                      onChanged: _onChanged,
                      // validator: FormBuilderValidators.compose(
                      //     [FormBuilderValidators.required()]),
                      options:
                      ['None', 'half of a pack', '1 pack', '2 packs', 'More than 2 packs']
                          .map((lang) => FormBuilderFieldOption(
                        value: lang,
                        child: Text(lang),
                      ))
                          .toList(growable: false),
                      controlAffinity: ControlAffinity.trailing,
                    ),
                    FormBuilderSegmentedControl(
                      decoration: const InputDecoration(
                        labelText: 'Your current state of health',
                      ),
                      name: 'health_rating',
                      // initialValue: 1,
                      // textStyle: TextStyle(fontWeight: FontWeight.bold),
                      options: List.generate(5, (i) => i + 1)
                          .map((number) => FormBuilderFieldOption(
                        value: number,
                        child: Text(
                          number.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                      ))
                          .toList(),
                      onChanged: _onChanged,
                    ),
                    FormBuilderSwitch(
                      title: const Text('I Accept the terms and conditions'),
                      name: 'accept_terms_switch',
                      initialValue: true,
                      onChanged: _onChanged,
                    ),
                    FormBuilderCheckboxGroup<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                          labelText: 'The vitamins you are taking these days'),
                      name: 'vitamins',
                      // initialValue: const ['vitamin C'],
                      options: const [
                        FormBuilderFieldOption(value: 'vitamin A'),
                        FormBuilderFieldOption(value: 'vitamin B'),
                        FormBuilderFieldOption(value: 'vitamin C'),
                        FormBuilderFieldOption(value: 'vitamin D'),
                        FormBuilderFieldOption(value: 'None'),
                      ],
                      onChanged: _onChanged,
                      separator: const VerticalDivider(
                        width: 10,
                        thickness: 5,
                        color: Colors.red,
                      ),
                      // validator: FormBuilderValidators.compose([
                      //   FormBuilderValidators.minLength(1),
                      //   FormBuilderValidators.maxLength(3),
                      // ]),
                    ),
                    FormBuilderFilterChip<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                          labelText: 'Your recent symptoms of illness'),
                      name: 'illness_filter',
                      selectedColor: Colors.red,
                      options: const [
                        FormBuilderChipOption(
                          value: 'Dizziness',
                          avatar: CircleAvatar(child: Text('D')),
                        ),
                        FormBuilderChipOption(
                          value: 'Headache',
                          avatar: CircleAvatar(child: Text('H')),
                        ),
                        FormBuilderChipOption(
                          value: 'Tired(exhausted)',
                          avatar: CircleAvatar(child: Text('T')),
                        ),
                        FormBuilderChipOption(
                          value: 'Orthostatic hypotension',
                          avatar: CircleAvatar(child: Text('O')),
                        ),
                        FormBuilderChipOption(
                          value: 'None',
                          avatar: CircleAvatar(child: Text('N')),
                        ),
                      ],
                      onChanged: _onChanged,
                      // validator: FormBuilderValidators.compose([
                      //   FormBuilderValidators.minLength(1),
                      //   FormBuilderValidators.maxLength(3),
                      // ]),
                    ),
                    FormBuilderChoiceChip<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                          labelText:
                          'symptoms that you wish to improve'),
                      name: 'illness_choice',
                      initialValue: 'None',
                      options: const [
                        FormBuilderChipOption(
                          value: 'Dizziness',
                          avatar: CircleAvatar(child: Text('D')),
                        ),
                        FormBuilderChipOption(
                          value: 'Headache',
                          avatar: CircleAvatar(child: Text('H')),
                        ),
                        FormBuilderChipOption(
                          value: 'Tired(exhausted)',
                          avatar: CircleAvatar(child: Text('T')),
                        ),
                        FormBuilderChipOption(
                          value: 'Orthostatic hypotension',
                          avatar: CircleAvatar(child: Text('O')),
                        ),
                        FormBuilderChipOption(
                          value: 'None',
                          avatar: CircleAvatar(child: Text('N')),
                        ),
                      ],
                      onChanged: _onChanged,
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          debugPrint(_formKey.currentState?.value.toString());
                        } else {
                          debugPrint(_formKey.currentState?.value.toString());
                          debugPrint('validation failed');
                        }
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _formKey.currentState?.reset();
                      },
                      // color: Theme.of(context).colorScheme.secondary,
                      child: Text(
                        'Reset',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}