enum Medal {gold, silver, bronze}
control1() {
    // Switch statement with enum
    enum Medal {gold, silver, bronze}
    var price;
    var medal = Medal.silver;
    switch (medal) {
        case Medal.gold: price = 10; break;
        case Medal.silver: price = 20; break;
        default: price = 30; 
    }
    print(price);
}

void main()
{
  control1();
}