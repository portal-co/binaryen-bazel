def _intrinsics_impl(ctx):
    #"substitutions": attr.string_dict(),
    substitutions = {
        "@WASM_INTRINSICS_SIZE@": "99",
        "@WASM_INTRINSICS_EMBED@": "\"bar\""
    }

    ctx.actions.expand_template(
        template = ctx.file.template,
        output = ctx.outputs.output,
        substitutions = substitutions,
    )
    return [
        DefaultInfo(files = depset([ctx.outputs.output])),
    ]

intrinsics = rule(
    implementation = _intrinsics_impl,
    attrs = {
        "data": attr.label(
            mandatory = True,
            allow_single_file = True,
            default = "wasm-intrinsics.wat"
        ),
        "template": attr.label(
            mandatory = True,
            allow_single_file = True,
            default = "WasmIntrinsics.cpp.in"
        ),
        "output": attr.output(
            mandatory = True,
        ),
    },
)
