//choose_weighted(item1, chance1, item2, chance2, etc.)
var chancesum, multiplier, result, sum;
chancesum = 0;
multiplier = 0;
for (var i=0; i<floor(argument_count/2); i++) {
    chancesum += argument[i+1];
    var dec = get_decimals(argument[i*2+1]);
    if (dec > multiplier) multiplier = dec;
}
chancesum *= power(10, multiplier);
result = random(chancesum)*power(10, 0-multiplier);
sum = 0;
for (var i=0; i<floor(argument_count/2); i++) {
    if (result > sum && result <= sum+argument[i*2+1]) return argument[i*2];
    sum += argument[i*2+1];
}
