load("@rules_cc//cc:defs.bzl", "cc_binary", "cc_library")
load("]:perl_genrule.bzl", "perl_genrule")

perl_genrule(
    name = "perlasm_genfiles",
    srcs_to_outs = {
        "assembly.pl": "assembly.s" 
    }
)

cc_library(
    name = "wrapper",
    srcs = ["assembly.s"],
    hdrs = [],
    deps = [":perlasm_genfiles"]
)

cc_binary(
    name = "main",
    srcs = ["main.cc"],
    deps = [":wrapper"]
)