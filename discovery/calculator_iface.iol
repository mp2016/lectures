type SumRequest:void {
  .number[2,*]:int
}

type SubRequest:void {
  .x:int
  .y:int
}

interface CalculatorIface {
RequestResponse:
  sum(SumRequest)(int),
  subtract(SubRequest)(int)
}
