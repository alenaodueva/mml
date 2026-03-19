/*
 Haversine formula implementation in AMPL
*/

param pi := 3.14159265358979;

param dc_lat_r {w in WAREHOUSES} := dclat[w] * pi / 180;
param dc_lon_r {w in WAREHOUSES} := dclon[w] * pi / 180;
param store_lat_r {c in CLIENTS} := storelat[c] * pi / 180;
param store_lon_r {c in CLIENTS} := storelon[c] * pi / 180;

param delta_lon_r {w in WAREHOUSES, c in CLIENTS} :=
    store_lon_r[c] - dc_lon_r[w];

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

param dist {w in WAREHOUSES, c in CLIENTS} :=
    max(delta[w,c] * km_radian * rdf, mindistance);
