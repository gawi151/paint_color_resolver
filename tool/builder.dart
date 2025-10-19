import 'package:build/build.dart';

/// Builder that copies the (hidden, `build_to: cache`) output of
/// `build_web_compilers` into `web/` (visible, this builder is defined with
/// `build_to: source`).
class CopyCompiledJs extends Builder {
  /// The [options] parameter is required by the build framework's contract
  /// for builder instantiation, even though it's not used by this builder.
  // ignore: avoid_unused_constructor_parameters
  CopyCompiledJs([BuilderOptions? options]);

  @override
  Future<void> build(BuildStep buildStep) async {
    final inputId = AssetId(buildStep.inputId.package, 'web/worker.dart.js');
    final input = await buildStep.readAsBytes(inputId);
    await buildStep.writeAsBytes(buildStep.allowedOutputs.single, input);
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        r'$package$': ['web/drift_worker.js']
      };
}
