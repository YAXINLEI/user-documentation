<?hh

namespace Hack\UserDocumentation\Classes\Traits\Examples\PropertyConflict;

trait T1 {
  public static int $x = 0;

  public static function even() : void {
    invariant(static::$x % 2 == 0, 'error, not even\n');
    static::$x = static::$x + 2;
  }
}

trait T2 {
  public static int $x = 0;

  public static function inc() : void {
    static::$x = static::$x + 1;
  }
}

class C {
  use T1;
  use T2;

  public static function foo() : void {
    static::inc();
    static::even();
  }
}

<<__EntryPoint>>
function main() : void {
  try {
    C::foo();
  } catch (\Exception $ex) {
    echo "Caught an exception\n";
  }
}