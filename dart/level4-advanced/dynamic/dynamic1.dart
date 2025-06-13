void variables1()
{
    int value = 18;
    String myName = "Alberto";
    print(value.runtimeType); // int 
    print(myName.runtimeType); // String
}

void variables2()
{
    // Dart sets the type correctly
    var value = 18;
    var myName = "Alberto";
    print(value.runtimeType); // int 
    // You can't assign String type value to value as it is assigned to int type value.
    print(myName.runtimeType); // String
}

void variables3()
{
    // Dart changes the type correctly
    dynamic value = 18;
    print(value.runtimeType); // int     
    value = 'Alberto';
    print(value.runtimeType); // String 
}

void main()
{
    variables1();
    variables2();
    variables3();
}