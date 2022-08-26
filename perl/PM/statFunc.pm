#!/usr/bin/perl

package statFunc;

use POSIX;
use mathPlus; 

# create normal function analytics C.I / p-value

sub Quartiles {

    my $array_ref = shift;
    my $quartileVal = shift // 0.5;

    my @array = @$array_ref;
    my $arrayLength = @array;
    my @sortArray = sort { $a <=> $b } @array;
    
    my $medianIndex = ( ( $arrayLength + 1 ) * $quartileVal ) - 1;
    my $firstIndex = floor($medianIndex);
    my $secondIndex = ceil($medianIndex);

    my $quartile = ( @sortArray[$firstIndex] + @sortArray[$secondIndex] ) / 2;

    return($quartile);

}

sub IQR {

    my $array_ref = shift;

    $firstQuartile = &Quartiles($array_ref,0.25);
    $thirdQuartile = &Quartiles($array_ref,0.75);

    $interQR = $thirdQuartile - $firstQuartile;

    return($interQR);

}

sub removeOutliers {
    
    my $array_ref = shift;

    my $interQR = &IQR($array_ref);
    my $firstQuartile = &Quartiles($array_ref,0.25);
    my $thirdQuartile = &Quartiles($array_ref,0.75);

    my $upperFence = $thirdQuartile + $interQR * 1.5;
    my $lowerFence = $firstQuartile - $interQR * 1.5;

    my @array = @$array_ref;
    my @sortArray = sort { $a <=> $b } @array;

    my $switch = "TRUE";

    while($switch ne "FALSE") {

        if ( @sortArray[0] < $lowerFence ) {
            splice(@sortArray,0,1);
        } else {
            $switch = "FALSE"
        }

    }

    my $arrayLength = @sortArray;
    my $switch = "TRUE";

    while($switch ne "FALSE") {

        if ( @sortArray[-1] > $upperFence ) {
            splice(@sortArray,-1,1);
        } else {
            $switch = "FALSE"
        }

    }

    return(\@sortArray);

}



sub mean {

    my $array_ref = shift;
    my @array = @$array_ref;

    my $arrayLength = @array;
    my $sum;

    for ( my $i = 0; $i < $arrayLength; $i++ ) {
        $sum += @array[$i];
    }

    my $mean = $sum / $arrayLength;

    return($mean);

}


sub variance {
    
    my $array_ref = shift;
    my $dataType = shift // "S";

    my $mean = &mean($array_ref);

    my @array = @$array_ref;
    my $arrayLength = @array;

    if ($dataType eq "P") {
        $denom = $arrayLength;
    } else {
        $denom = $arrayLength - 1;
    }

    for ( my $i = 0; $i < $arrayLength; $i++ ) {
        $var += ( ( @array[$i] - $mean ) ** 2 ) / ( $denom );
    }

    return($var);

}


sub sd {

    my $array_ref = shift;
    my $dataType = shift // "S";

    my $var = &variance($array_ref,$dataType);

    my $sd = sqrt($var);

    return($sd); 

}

1;