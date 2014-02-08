///get_decimals(real)
var maxdigits, multiplier, calcno;
maxdigits = 100;
multiplier = 0;
calcno = argument0*power(10, multiplier);
while (round(calcno)!=calcno) {
    if (multiplier>=maxdigits) return maxdigits;
    multiplier++;
    calcno = argument0*power(10, multiplier);
}
return multiplier;
