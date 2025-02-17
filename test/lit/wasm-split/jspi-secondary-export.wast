;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; RUN: wasm-opt %s --jspi --pass-arg=jspi-exports@foo --pass-arg=jspi-split-module -all -S -o %t.jspi.wast
;; RUN: wasm-split %t.jspi.wast --export-prefix='%' -g -o1 %t.1.wasm -o2 %t.2.wasm --jspi --enable-reference-types
;; RUN: wasm-dis %t.1.wasm | filecheck %s --check-prefix PRIMARY
;; RUN: wasm-dis %t.2.wasm | filecheck %s --check-prefix SECONDARY

;; Ensure exported functions are not moved to secondary module when JSPI is
;; enabled.

(module
 ;; PRIMARY:      (type $0 (func (param i32) (result i32)))

 ;; PRIMARY:      (type $3 (func (param externref)))

 ;; PRIMARY:      (type $1 (func (param externref i32) (result i32)))

 ;; PRIMARY:      (type $2 (func))

 ;; PRIMARY:      (import "env" "__load_secondary_module" (func $import$__load_secondary_module (param externref)))

 ;; PRIMARY:      (import "placeholder" "0" (func $placeholder_0 (param i32) (result i32)))

 ;; PRIMARY:      (global $suspender (mut externref) (ref.null noextern))

 ;; PRIMARY:      (global $global$1 (mut i32) (i32.const 0))

 ;; PRIMARY:      (table $0 1 funcref)

 ;; PRIMARY:      (elem $0 (i32.const 0) $placeholder_0)

 ;; PRIMARY:      (export "foo" (func $export$foo))
 (export "foo" (func $foo))
 ;; SECONDARY:      (type $0 (func (param i32) (result i32)))

 ;; SECONDARY:      (import "primary" "%table" (table $timport$0 1 funcref))

 ;; SECONDARY:      (import "primary" "%global" (global $suspender (mut externref)))

 ;; SECONDARY:      (import "primary" "load_secondary_module_status" (global $gimport$1 (mut i32)))

 ;; SECONDARY:      (elem $0 (i32.const 0) $foo)

 ;; SECONDARY:      (func $foo (param $0 i32) (result i32)
 ;; SECONDARY-NEXT:  (i32.const 0)
 ;; SECONDARY-NEXT: )
 (func $foo (param i32) (result i32)
  (i32.const 0)
 )
)
;; PRIMARY:      (export "load_secondary_module_status" (global $global$1))

;; PRIMARY:      (export "%table" (table $0))

;; PRIMARY:      (export "%global" (global $suspender))

;; PRIMARY:      (func $export$foo (param $susp externref) (param $0 i32) (result i32)
;; PRIMARY-NEXT:  (global.set $suspender
;; PRIMARY-NEXT:   (local.get $susp)
;; PRIMARY-NEXT:  )
;; PRIMARY-NEXT:  (if
;; PRIMARY-NEXT:   (i32.eqz
;; PRIMARY-NEXT:    (global.get $global$1)
;; PRIMARY-NEXT:   )
;; PRIMARY-NEXT:   (call $__load_secondary_module)
;; PRIMARY-NEXT:  )
;; PRIMARY-NEXT:  (call_indirect (type $0)
;; PRIMARY-NEXT:   (local.get $0)
;; PRIMARY-NEXT:   (i32.const 0)
;; PRIMARY-NEXT:  )
;; PRIMARY-NEXT: )

;; PRIMARY:      (func $__load_secondary_module
;; PRIMARY-NEXT:  (local $0 externref)
;; PRIMARY-NEXT:  (local.set $0
;; PRIMARY-NEXT:   (global.get $suspender)
;; PRIMARY-NEXT:  )
;; PRIMARY-NEXT:  (call $import$__load_secondary_module
;; PRIMARY-NEXT:   (global.get $suspender)
;; PRIMARY-NEXT:  )
;; PRIMARY-NEXT:  (global.set $suspender
;; PRIMARY-NEXT:   (local.get $0)
;; PRIMARY-NEXT:  )
;; PRIMARY-NEXT: )
