"""Generate files with perl. These are assumed to be .pl files as src and .s file as output.
"""

load("@rules_cc//cc:defs.bzl", "CcInfo", "cc_common")

def run_generation(ctx, src, out, binary_invocation):
    """Run the generation command.

    Args:
        ctx: The context object from bazel.
        src: The source target.
        out: The output target.
        binary_invocation: The binary to run to do generation.
    Returns:
        The output target as a file. Should only be one.
    """
    out_as_file = ctx.actions.declare_file(out)
    src_files = src.files
    perl_generate_file = ctx.file.perl_generate_file
    for src_as_file in src_files.to_list():
        ctx.actions.run(
            inputs = [src_as_file],
            outputs = [out_as_file],
            executable = perl_generate_file,
            arguments = [binary_invocation, src_as_file.path, out_as_file.path, "elf"],
            mnemonic = "GenerateAssemblyFromPerlScripts",
            progress_message = "Generating file {} from script {}".format(out_as_file.path, src_as_file.path),
            toolchain =
                "@rules_perl//:current_toolchain",
        )
    return out_as_file

def _perl_genrule_impl(ctx):
    binary_invocation = "perl"
    out_files = []
    
    for src, out in ctx.attr.srcs_to_outs.items():
        out_as_file = run_generation(ctx, src, out, binary_invocation)
        out_files.append(out_as_file)

    cc_info = CcInfo(
        compilation_context = cc_common.create_compilation_context(direct_private_headers = out_files),
    )
    ret = [DefaultInfo(files = depset(out_files)), cc_info]
    return ret

perl_genrule = rule(
    implementation = _perl_genrule_impl,
    doc = "Generate files using perl.",
    attrs = {
        # The dict of srcs to their outs.
        "srcs_to_outs": attr.label_keyed_string_dict(allow_files = True, doc = "Dict of input to output files from their source script."),
        # Script that handles the file generation and existence check.
        "perl_generate_file": attr.label(
            allow_single_file = True,
            executable = True,
            cfg = "exec"
            default = "//:perl_generate_file.sh"
        ),
    },
)
