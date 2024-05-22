load("@rules_rust//wasm_bindgen/private:wasm_bindgen.bzl", "WASM_BINDGEN_ATTR", "rust_wasm_bindgen_action")

WASM2JS_ATTR = {"_wasm2js": attr.label(executable = True, default = "//src/tools:wasm2js", cfg = "exec")}

def wasm2js(ctx, file):
    new = ctx.actions.declare_file(file.path.replace(".wasm", ".js"))
    ctx.actions.run(
        executable = ctx.executable._wasm2js,
        inputs = [file],
        outputs = [new],
        arguments = [fiel.path, "-o", new.path],
    )
    return new

WASM2JS_WASM_BINDGEN_ATTR = WASM_BINDGEN_ATTR | WASM2JS_ATTR

def wasm2js_wasm_bindgen_action(ctx, **kwargs):
    info = rust_wasm_bindgen_action(ctx = ctx, **kwargs)
    wasm_js = wasm2js(ctx, info.wasm)
    return struct(
        js = depset([wasm_js], transitive = [info.js]),
        ts = info.ts,
    )
