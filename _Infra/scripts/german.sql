select
    low_bound.temperature as LowTemp,
    low_bound.correction as LowCorr,
    high_bound.temperature as HighTemp,
    high_bound.correction as HighCorr
from
    (
   select temperature, correction
     from calc_temperature_correction
   where temperature <= least(greatest(50, 0), 40)
     order by temperature desc
   limit 1
  ) as low_bound,

    (
   select temperature, correction
     from calc_temperature_correction
     where temperature >= least(greatest(50, 0), 40)
     order by temperature
   limit 1
    ) as high_bound;