-module(elixir_error_handler).
-export([undefined_function/3, undefined_lambda/3]).

undefined_function(Module, Func, Args) ->
  ensure_loaded(Module),
  error_handler:undefined_function(Module, Func, Args).

undefined_lambda(Module, Func, Args) ->
  ensure_loaded(Module),
  error_handler:undefined_lambda(Module, Func, Args).

ensure_loaded(Module) ->
  case code:ensure_loaded(Module) of
    { module, _ } -> [];
    { error, _ } ->
      Parent = get(elixir_parent_compiler),
      Parent ! { waiting, self(), Module },
      receive { release, Parent } -> ok end
  end.
