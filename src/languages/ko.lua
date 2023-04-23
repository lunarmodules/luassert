local s = require("say")

s:set_namespace("ko")

s:set("assertion.same.positive", "객체 내용이 같을 것으로 기대함.\n실제값:\n%s\n기대값:\n%s")
s:set(
  "assertion.same.negative",
  "객체 내용이 같지 않을 것으로 기대함.\n실제값:\n%s\n기대하지 않은 값:\n%s"
)

s:set("assertion.equals.positive", "객체가 같을 것으로 기대함.\n실제값:\n%s\n기대값:\n%s")
s:set(
  "assertion.equals.negative",
  "객체가 같지 않을 것으로 기대함.\n실제값:\n%s\n기대하지 않은 값:\n%s"
)

s:set("assertion.near.positive", "값이 가까울 것으로 기대함.\n실제값:\n%s\n기대값:\n%s +/- %s")
s:set(
  "assertion.near.negative",
  "값이 가깝지 않을 것으로 기대함.\n실제값:\n%s\n기대하지 않은 값:\n%s +/- %s"
)

s:set("assertion.matches.positive", "문자열이 일치할 것으로 기대함.\n실제값:\n%s\n기대값:\n%s")
s:set(
  "assertion.matches.negative",
  "문자열이 일치하지 않을 것으로 기대함.\n실제값:\n%s\n기대하지 않은 값:\n%s"
)

s:set("assertion.unique.positive", "객체가 고유할 것으로 기대함:\n%s")
s:set("assertion.unique.negative", "객체가 고유하지 않을 것으로 기대함:\n%s")

s:set("assertion.error.positive", "에러를 기대함.\n발생:\n%s\n기대값:\n%s")
s:set("assertion.error.negative", "에러를 기대하지 않음. 발생:\n%s")

s:set("assertion.truthy.positive", "참에 준하는 값을 기대함. 실제값:\n%s")
s:set("assertion.truthy.negative", "참에 준하지 않는 값을 기대함. 실제값:\n%s")

s:set("assertion.falsy.positive", "거짓에 준하는 값을 기대함. 실제값:\n%s")
s:set("assertion.falsy.negative", "거짓에 준하지 않는 값을 기대함. 실제값:\n%s")

s:set("assertion.called.positive", "%s번 호출될 것으로 기대함. %s번 호출됨.")
s:set("assertion.called.negative", "정확히 %s번 호출되면 안되지만 호출됨.")

s:set("assertion.called_at_least.positive", "적어도 %s번 호출될 것으로 기대함. %s번 호출됨.")
s:set("assertion.called_at_most.positive", "많아도 %s번 호출될 것으로 기대함. %s번 호출됨.")
s:set("assertion.called_more_than.positive", "%s번 초과로 호출될 것으로 기대함. %s번 호출됨.")
s:set("assertion.called_less_than.positive", "%s번 미만으로 호출될 것으로 기대함. %s번 호출됨.")

s:set(
  "assertion.called_with.positive",
  "함수가 기대한 인자와 일치하는 호출이 없습니다.\n(있다면) 마지막 호출:\n%s\n기대값:\n%s"
)
s:set(
  "assertion.called_with.negative",
  "함수가 기대하지 않은 인자와 일치하는 호출이 한 번 이상 있습니다.\n(마지막) 일치 호출:\n%s\n기대하지 않은 값:\n%s"
)

s:set(
  "assertion.returned_with.positive",
  "함수가 기대한 인자와 일치하는 반환값이 없습니다.\n(있다면) 마지막 반환값:\n%s\n기대값:\n%s"
)
s:set(
  "assertion.returned_with.negative",
  "함수가 기대하지 않은 인자와 일치하는 반환값이 있습니다.\n(마지막) 일치 반환값:\n%s\n기대하지 않은 값:\n%s"
)

s:set("assertion.returned_arguments.positive", "%s 인자로 호출될 것으로 기대함. %s 인자로 호출됨.")
s:set(
  "assertion.returned_arguments.negative",
  "%s 인자로 호출되지 않을 것으로 기대함. %s 인자로 호출됨."
)

-- errors
s:set(
  "assertion.internal.argtolittle",
  "'%s' 함수는 최소 %s개의 인자를 필요로 합니다. 받은 인자: %s"
)
s:set("assertion.internal.badargtype", "인자 #%s 가 '%s' 함수에 주어짐. (기대값: %s, 실제값: %s)")
