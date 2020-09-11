import '../css/index.css';

console.log('hello world');

console.log('Another hello world');

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