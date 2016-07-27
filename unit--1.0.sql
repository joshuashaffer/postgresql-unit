-- type definition

CREATE TYPE unit;

CREATE OR REPLACE FUNCTION unit_in(cstring)
  RETURNS unit
  AS '$libdir/unit'
  LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION unit_out(unit)
  RETURNS cstring
  AS '$libdir/unit'
  LANGUAGE C IMMUTABLE STRICT;

CREATE TYPE unit (
	internallength = 16,
	input = unit_in,
	output = unit_out,
	alignment = double
);

-- constructors

CREATE FUNCTION unit(double precision DEFAULT 1.0)
	RETURNS unit
	AS '$libdir/unit', 'dbl2unit'
	LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION meter(double precision DEFAULT 1.0)
	RETURNS unit
	AS '$libdir/unit', 'unit_meter'
	LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION kilogram(double precision DEFAULT 1.0)
	RETURNS unit
	AS '$libdir/unit', 'unit_kilogram'
	LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION second(double precision DEFAULT 1.0)
	RETURNS unit
	AS '$libdir/unit', 'unit_second'
	LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION ampere(double precision DEFAULT 1.0)
	RETURNS unit
	AS '$libdir/unit', 'unit_ampere'
	LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION kelvin(double precision DEFAULT 1.0)
	RETURNS unit
	AS '$libdir/unit', 'unit_kelvin'
	LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION mole(double precision DEFAULT 1.0)
	RETURNS unit
	AS '$libdir/unit', 'unit_mole'
	LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION candela(double precision DEFAULT 1.0)
	RETURNS unit
	AS '$libdir/unit', 'unit_candela'
	LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION byte(double precision DEFAULT 1.0)
	RETURNS unit
	AS '$libdir/unit', 'unit_byte'
	LANGUAGE C IMMUTABLE STRICT;

-- extractors

CREATE FUNCTION value(unit)
	RETURNS double precision
	AS '$libdir/unit', 'unit_value'
	LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION dimension(unit)
	RETURNS unit
	AS '$libdir/unit', 'unit_dimension'
	LANGUAGE C IMMUTABLE STRICT;

-- operators

CREATE FUNCTION unit_add(unit, unit)
	RETURNS unit
	AS '$libdir/unit'
	LANGUAGE C IMMUTABLE STRICT;

CREATE OPERATOR + (
	leftarg = unit,
	rightarg = unit,
	procedure = unit_add,
	commutator = +
);

CREATE FUNCTION unit_sub(unit, unit)
	RETURNS unit
	AS '$libdir/unit'
	LANGUAGE C IMMUTABLE STRICT;

CREATE OPERATOR - (
	leftarg = unit,
	rightarg = unit,
	procedure = unit_sub
);

CREATE FUNCTION unit_neg(unit)
	RETURNS unit
	AS '$libdir/unit'
	LANGUAGE C IMMUTABLE STRICT;

CREATE OPERATOR - (
	rightarg = unit,
	procedure = unit_neg
);

CREATE FUNCTION unit_mul(unit, unit)
	RETURNS unit
	AS '$libdir/unit'
	LANGUAGE C IMMUTABLE STRICT;

CREATE OPERATOR * (
	leftarg = unit,
	rightarg = unit,
	procedure = unit_mul,
	commutator = *
);

CREATE FUNCTION dbl_unit_mul(double precision, unit)
	RETURNS unit
	AS '$libdir/unit'
	LANGUAGE C IMMUTABLE STRICT;

CREATE OPERATOR * (
	leftarg = double precision,
	rightarg = unit,
	procedure = dbl_unit_mul,
	commutator = *
);

CREATE FUNCTION unit_dbl_mul(unit, double precision)
	RETURNS unit
	AS '$libdir/unit'
	LANGUAGE C IMMUTABLE STRICT;

CREATE OPERATOR * (
	leftarg = unit,
	rightarg = double precision,
	procedure = unit_dbl_mul,
	commutator = *
);

CREATE FUNCTION unit_div(unit, unit)
	RETURNS unit
	AS '$libdir/unit'
	LANGUAGE C IMMUTABLE STRICT;

CREATE OPERATOR / (
	leftarg = unit,
	rightarg = unit,
	procedure = unit_div
);

CREATE FUNCTION dbl_unit_div(double precision, unit)
	RETURNS unit
	AS '$libdir/unit'
	LANGUAGE C IMMUTABLE STRICT;

CREATE OPERATOR / (
	leftarg = double precision,
	rightarg = unit,
	procedure = dbl_unit_div
);

CREATE FUNCTION unit_dbl_div(unit, double precision)
	RETURNS unit
	AS '$libdir/unit'
	LANGUAGE C IMMUTABLE STRICT;

CREATE OPERATOR / (
	leftarg = unit,
	rightarg = double precision,
	procedure = unit_dbl_div
);

CREATE FUNCTION unit_pow(unit, int)
	RETURNS unit
	AS '$libdir/unit'
	LANGUAGE C IMMUTABLE STRICT;

CREATE OPERATOR ^ (
	leftarg = unit,
	rightarg = int,
	procedure = unit_pow
);

CREATE FUNCTION unit_at(unit, cstring)
	RETURNS cstring
	AS '$libdir/unit'
	LANGUAGE C IMMUTABLE STRICT;

CREATE OPERATOR @ (
	leftarg = unit,
	rightarg = cstring,
	procedure = unit_at
);

-- derived units

CREATE FUNCTION radian    (double precision DEFAULT 1.0) -- m·m^-1
	RETURNS unit
	AS $$SELECT meter($1) / meter()$$
	LANGUAGE SQL IMMUTABLE STRICT;
CREATE FUNCTION steradian (double precision DEFAULT 1.0) -- m^2·m^-2
	RETURNS unit
	AS $$SELECT meter($1) * meter() / meter()^2$$
	LANGUAGE SQL IMMUTABLE STRICT;
CREATE FUNCTION hertz     (double precision DEFAULT 1.0) -- s^-1
	RETURNS unit
	AS $$SELECT $1 / second()$$
	LANGUAGE SQL IMMUTABLE STRICT;
CREATE FUNCTION newton    (double precision DEFAULT 1.0) -- kg·m·s^-2
	RETURNS unit
	AS $$SELECT kilogram($1) * meter() / second()^2$$
	LANGUAGE SQL IMMUTABLE STRICT;
CREATE FUNCTION pascal    (double precision DEFAULT 1.0) -- N/m^2
	RETURNS unit
	AS $$SELECT newton($1) / meter()^2 $$
	LANGUAGE SQL IMMUTABLE STRICT;
CREATE FUNCTION joule     (double precision DEFAULT 1.0) -- N·m
	RETURNS unit
	AS $$SELECT newton($1) * meter()$$
	LANGUAGE SQL IMMUTABLE STRICT;
CREATE FUNCTION watt      (double precision DEFAULT 1.0) -- J/s
	RETURNS unit
	AS $$SELECT joule($1) / second()$$
	LANGUAGE SQL IMMUTABLE STRICT;
CREATE FUNCTION coulomb   (double precision DEFAULT 1.0) -- A·s
	RETURNS unit
	AS $$SELECT ampere($1) * second()$$
	LANGUAGE SQL IMMUTABLE STRICT;
CREATE FUNCTION volt      (double precision DEFAULT 1.0) -- W/A
	RETURNS unit
	AS $$SELECT watt($1) / ampere() $$
	LANGUAGE SQL IMMUTABLE STRICT;
CREATE FUNCTION farad     (double precision DEFAULT 1.0) -- C/V
	RETURNS unit
	AS $$SELECT coulomb($1) / volt() $$
	LANGUAGE SQL IMMUTABLE STRICT;
CREATE FUNCTION ohm       (double precision DEFAULT 1.0) -- V/A
	RETURNS unit
	AS $$SELECT volt($1) / ampere() $$
	LANGUAGE SQL IMMUTABLE STRICT;
CREATE FUNCTION siemens   (double precision DEFAULT 1.0) -- A/V
	RETURNS unit
	AS $$SELECT ampere($1) / volt()$$
	LANGUAGE SQL IMMUTABLE STRICT;
CREATE FUNCTION weber     (double precision DEFAULT 1.0) -- V·s
	RETURNS unit
	AS $$SELECT volt($1) * second()$$
	LANGUAGE SQL IMMUTABLE STRICT;
CREATE FUNCTION tesla     (double precision DEFAULT 1.0) -- Wb/m^2
	RETURNS unit
	AS $$SELECT weber($1) / meter()^2$$
	LANGUAGE SQL IMMUTABLE STRICT;
CREATE FUNCTION henry     (double precision DEFAULT 1.0) -- Wb/A
	RETURNS unit
	AS $$SELECT weber($1) / ampere()$$
	LANGUAGE SQL IMMUTABLE STRICT;
CREATE FUNCTION celsius   (double precision DEFAULT 0.0) -- K relative to 273.15, default to 0°C
	RETURNS unit
	AS $$SELECT kelvin($1 + 273.15)$$
	LANGUAGE SQL IMMUTABLE STRICT;
CREATE FUNCTION lumen     (double precision DEFAULT 1.0) -- cd·sr
	RETURNS unit
	AS $$SELECT candela($1) * steradian()$$
	LANGUAGE SQL IMMUTABLE STRICT;
CREATE FUNCTION lux       (double precision DEFAULT 1.0) -- lm/m^2
	RETURNS unit
	AS $$SELECT lumen($1) / meter()^2$$
	LANGUAGE SQL IMMUTABLE STRICT;
CREATE FUNCTION becquerel (double precision DEFAULT 1.0) -- s^-1
	RETURNS unit
	AS $$SELECT $1 / second()$$
	LANGUAGE SQL IMMUTABLE STRICT;
CREATE FUNCTION gray      (double precision DEFAULT 1.0) -- J/kg
	RETURNS unit
	AS $$SELECT joule($1) / kilogram()$$
	LANGUAGE SQL IMMUTABLE STRICT;
CREATE FUNCTION sievert   (double precision DEFAULT 1.0) -- J/kg
	RETURNS unit
	AS $$SELECT joule($1)/ kilogram()$$
	LANGUAGE SQL IMMUTABLE STRICT;
CREATE FUNCTION katal     (double precision DEFAULT 1.0) -- mol·s^-1
	RETURNS unit
	AS $$SELECT mole($1) / second()$$
	LANGUAGE SQL IMMUTABLE STRICT;

-- Non-SI units accepted for use with the SI
--minute, hour, day, degree of arc, minute of arc, second of arc, hectare, litre, tonne, astronomical unit and [deci]bel

CREATE FUNCTION minute    (double precision DEFAULT 1.0)
	RETURNS unit
	AS $$SELECT second($1 * 60)$$
	LANGUAGE SQL IMMUTABLE STRICT;
CREATE FUNCTION hour      (double precision DEFAULT 1.0)
	RETURNS unit
	AS $$SELECT second($1 * 3600)$$
	LANGUAGE SQL IMMUTABLE STRICT;
CREATE FUNCTION day       (double precision DEFAULT 1.0)
	RETURNS unit
	AS $$SELECT second($1 * 86400)$$
	LANGUAGE SQL IMMUTABLE STRICT;
CREATE FUNCTION degree_arc(double precision DEFAULT 1.0)
	RETURNS unit
	AS $$SELECT $1 * '1'::unit * pi() / 180$$
	LANGUAGE SQL IMMUTABLE STRICT;
CREATE FUNCTION minute_arc(double precision DEFAULT 1.0)
	RETURNS unit
	AS $$SELECT $1 * '1'::unit * pi() / 180 / 60$$
	LANGUAGE SQL IMMUTABLE STRICT;
CREATE FUNCTION second_arc(double precision DEFAULT 1.0)
	RETURNS unit
	AS $$SELECT $1 * '1'::unit * pi() / 180 / 3600$$
	LANGUAGE SQL IMMUTABLE STRICT;
CREATE FUNCTION hectare   (double precision DEFAULT 1.0)
	RETURNS unit
	AS $$SELECT $1 * meter(100)^2$$
	LANGUAGE SQL IMMUTABLE STRICT;
CREATE FUNCTION liter     (double precision DEFAULT 1.0)
	RETURNS unit
	AS $$SELECT $1 * meter(0.1)^3$$
	LANGUAGE SQL IMMUTABLE STRICT;
CREATE FUNCTION tonne     (double precision DEFAULT 1.0)
	RETURNS unit
	AS $$SELECT kilogram($1 * 1000)$$
	LANGUAGE SQL IMMUTABLE STRICT;
CREATE FUNCTION au        (double precision DEFAULT 1.0)
	RETURNS unit
	AS $$SELECT meter($1 * 149597870700)$$
	LANGUAGE SQL IMMUTABLE STRICT;
CREATE FUNCTION decibel   (double precision DEFAULT 0.0)
	RETURNS double precision
	AS $$SELECT 10.0^($1 / 10.0)$$
	LANGUAGE SQL IMMUTABLE STRICT;

-- comparisons

CREATE FUNCTION unit_lt(unit, unit) RETURNS bool
   AS '$libdir/unit' LANGUAGE C IMMUTABLE STRICT;
CREATE FUNCTION unit_le(unit, unit) RETURNS bool
   AS '$libdir/unit' LANGUAGE C IMMUTABLE STRICT;
CREATE FUNCTION unit_eq(unit, unit) RETURNS bool
   AS '$libdir/unit' LANGUAGE C IMMUTABLE STRICT;
CREATE FUNCTION unit_ne(unit, unit) RETURNS bool
   AS '$libdir/unit' LANGUAGE C IMMUTABLE STRICT;
CREATE FUNCTION unit_ge(unit, unit) RETURNS bool
   AS '$libdir/unit' LANGUAGE C IMMUTABLE STRICT;
CREATE FUNCTION unit_gt(unit, unit) RETURNS bool
   AS '$libdir/unit' LANGUAGE C IMMUTABLE STRICT;

CREATE OPERATOR < (
	leftarg = unit, rightarg = unit, procedure = unit_lt,
	commutator = > , negator = >= ,
	restrict = scalarltsel, join = scalarltjoinsel
);
CREATE OPERATOR <= (
	leftarg = unit, rightarg = unit, procedure = unit_le,
	commutator = >= , negator = > ,
	restrict = scalarltsel, join = scalarltjoinsel
);
CREATE OPERATOR = (
	leftarg = unit, rightarg = unit, procedure = unit_eq,
	commutator = = , negator = <> ,
	restrict = eqsel, join = eqjoinsel
);
CREATE OPERATOR <> (
	leftarg = unit, rightarg = unit, procedure = unit_ne,
	commutator = <> , negator = = ,
	restrict = neqsel, join = neqjoinsel
);
CREATE OPERATOR >= (
	leftarg = unit, rightarg = unit, procedure = unit_ge,
	commutator = <= , negator = < ,
	restrict = scalargtsel, join = scalargtjoinsel
);
CREATE OPERATOR > (
	leftarg = unit, rightarg = unit, procedure = unit_gt,
	commutator = < , negator = <= ,
	restrict = scalargtsel, join = scalargtjoinsel
);

CREATE FUNCTION unit_cmp(unit, unit)
	RETURNS int4
	AS '$libdir/unit'
	LANGUAGE C IMMUTABLE STRICT;

CREATE OPERATOR CLASS unit_ops
	DEFAULT FOR TYPE unit USING btree AS
		OPERATOR 1 < ,
		OPERATOR 2 <= ,
		OPERATOR 3 = ,
		OPERATOR 4 >= ,
		OPERATOR 5 > ,
		FUNCTION 1 unit_cmp(unit, unit);

-- aggregates

CREATE AGGREGATE sum(unit)
(
	sfunc = unit_add,
	stype = unit
);

CREATE FUNCTION unit_least(unit, unit)
	RETURNS unit
	AS '$libdir/unit'
	LANGUAGE C IMMUTABLE STRICT;

CREATE AGGREGATE min(unit)
(
	sfunc = unit_least,
	stype = unit
);

CREATE FUNCTION unit_greatest(unit, unit)
	RETURNS unit
	AS '$libdir/unit'
	LANGUAGE C IMMUTABLE STRICT;

CREATE AGGREGATE max(unit)
(
	sfunc = unit_greatest,
	stype = unit
);

CREATE TYPE unit_accum_t AS (
	s unit,
	n bigint
);

CREATE FUNCTION unit_accum(a unit_accum_t, u unit)
	RETURNS unit_accum_t
	AS $$SELECT (CASE WHEN a.s = '0'::unit THEN u ELSE a.s + u END, a.n + 1)::unit_accum_t$$
	LANGUAGE SQL IMMUTABLE STRICT;

CREATE FUNCTION unit_avg(a unit_accum_t)
	RETURNS unit
	AS $$SELECT CASE WHEN a.n > 0 THEN a.s / a.n ELSE NULL END$$
	LANGUAGE SQL IMMUTABLE STRICT;

CREATE AGGREGATE avg(unit)
(
	sfunc = unit_accum,
	stype = unit_accum_t,
	finalfunc = unit_avg,
	initcond = '(0,0)'
);

