/*
 An approximate formula to compute shortest path distance from coordinates

 mindistance - a parameter used to prevent zero distance when points are in the same city
*/

param dist {w in WAREHOUSES, c in CLIENTS} :=
    max(rdf * sqrt((71.5 * (storelon[c] - dclon[w]))^2
                 + (111 * (storelat[c] - dclat[w]))^2),
        mindistance);

/* 
 For Russia, this formula produces an overstated distance, by ~10%
*/

/*
 Haversine formula implementation in AMPL
*/

# Convert lat/lon to radians
param pi := 3.14159265358979;

param dc_lat_r {w in WAREHOUSES} := dclat[w] * pi / 180;
param dc_lon_r {w in WAREHOUSES} := dclon[w] * pi / 180;
param store_lat_r {c in CLIENTS} := storelat[c] * pi / 180;
param store_lon_r {c in CLIENTS} := storelon[c] * pi / 180;

# longitude delta:
param delta_lon_r {w in WAREHOUSES, c in CLIENTS} :=
    store_lon_r[c] - dc_lon_r[w];

# the distance between points in radians:
param delta {w in WAREHOUSES, c in CLIENTS} :=
    atan(
        sqrt(
            (cos(store_lat_r[c]) * sin(delta_lon_r[w,c]))^2
            +
            (cos(dc_lat_r[w]) * sin(store_lat_r[c])
             - sin(dc_lat_r[w]) * cos(store_lat_r[c]) * cos(delta_lon_r[w,c]))^2
        )
        /
        (
            sin(dc_lat_r[w]) * sin(store_lat_r[c])
            + cos(dc_lat_r[w]) * cos(store_lat_r[c]) * cos(delta_lon_r[w,c])
        )
    );

param km_radian := 6372.795;

# Earth radius to convert from radians to km
param dist {w in WAREHOUSES, c in CLIENTS} :=
    max(delta[w,c] * km_radian * rdf, mindistance);  # distance in km
