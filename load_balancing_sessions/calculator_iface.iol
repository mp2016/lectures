type SumRequest:void {
  .number[2,*]:int
  .sid:string
}

type SubRequest:void {
  .x:int
  .y:int
  .sid:string
}

type Logout:void {
  .sid:string
}

interface CalculatorIface {
RequestResponse:
  login(string)(string) throws InvalidSecret,
  sum(SumRequest)(int),
  subtract(SubRequest)(int),
  logout(Logout)(void)
}
