// import '../css/index.css';
import '../sass/index.sass';

class A {
  constructor(a) {
    console.log(a)
    this.a = a;
  }

  foo() {
    console.log(1123123);
  }
}

console.log('hello world');

console.log('Another hello world');

new A(100).foo()

function foo() {
  let a = 100;
  console.log('hello world');
  console.log(a);
  console.log((() => { 
    console.log(11); 
    return 0; 
  })())
}

foo();