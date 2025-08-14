import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voldt/core/theme/app_pallete.dart';

class FinishJobDialog extends StatefulWidget {
  final String title;
  const FinishJobDialog({super.key, required this.title});

  @override
  State<FinishJobDialog> createState() =>
      _FinishJobDialogState();
}

class _FinishJobDialogState extends State<FinishJobDialog> {
  final _picker = ImagePicker();
  XFile? _file;

  Future<void> _pick() async {
    final f = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (!mounted) return;
    setState(() => _file = f);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 24,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            16,
            20,
            20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed:
                        () =>
                            Navigator.of(context).pop(null),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'OBS! Før opgaven kan afleveres, skal der uploades et billede som bevis for at opgaven er afleveret på den rigtige adresse.',
                style: TextStyle(
                  color: Colors.black87,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: InkWell(
                  onTap: _pick,
                  borderRadius: BorderRadius.circular(60),
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(
                        60,
                      ),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 42,
                      color: AppPallete.woltBlue,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(child: Text('Upload billede')),
              const SizedBox(height: 12),
              if (_file != null)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _file!.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPallete.woltBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        14,
                      ),
                    ),
                  ),
                  onPressed:
                      _file == null
                          ? null
                          : () {
                            // returner valgt fil til kaldende side
                            Navigator.of(
                              context,
                            ).pop<XFile?>(_file);
                          },
                  child: const Text(
                    'Aflever nu',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
