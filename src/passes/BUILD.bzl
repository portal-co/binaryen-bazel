def _intrinsics_impl(ctx):

    args = [ctx.file.data.path, ctx.outputs.output.path]

    ctx.actions.run(
        inputs  = [ctx.file.data],
        outputs = [ctx.outputs.output],
        arguments = args,
        executable = ctx.executable._tool
    )

intrinsics = rule(
    implementation = _intrinsics_impl,
    attrs = {
        "data": attr.label(
            mandatory = True,
            allow_single_file = True,
        ),
        "output": attr.output(
            mandatory = True
        ),
        "_tool": attr.label(
            allow_single_file = True,
            executable = True,
            cfg = "exec",
            default = "//src/tools:intrinsics_to_binary"
        )
    },
)
