# Reasoning about relative times of events in the life of Nonnsus

In the altar of the parish church in Molzbichl there is a tombstone with the only inscription in Austria from the 6th century. The Latin inscription [reads](https://de.wikipedia.org/wiki/Nonnosus)

> Here rests the servant of Christ, the deacon Nonnosus, who lived about 103 years. He died on September 2nd and was buried on July 20th at this place in the eleventh year of the indiction three years after the consulship of the most famous men Lampadius and Orestes.

The assertions made in this inscription can be modeled using the [OWL-Time ontology](https://www.w3.org/TR/owl-time/):

![OWL-Time model of assertions made in the inscription on the tombstone of Nonnosus](nonnosus.png)

See [this model in Turtle syntax](nonnosus.ttl).

From this model we can infer temporal boundaries on the possible dates of the birth and death of Nonnosus. To do this we need some inference rules. The rules used here are written in [Notation3](https://n3.restdesc.org/n3/), a superset of Turtle that also allows inference rules to be expressed.

The rule for inferring the year of the burial of Nonnosus, given the year of [the consulate of Lampadius and Orestes](https://www.trismegistos.org/period/2278), is:

```ttl
# If an interval has a known duration in years, and the year of start
# of the interval is known, then the year of the finish of interval
# can be inferred.
{
    ?i
      time:intervalStartedBy ?s ;
      time:intervalFinishedBy ?f ;
      time:hasDurationDescription [
        time:years ?years
      ] .

    ?s time:hasDateTimeDescription  [
      time:year ?s_y
    ] .

    ?f time:hasDateTimeDescription ?f_d .

    ( ?s_y ?years ) math:sum ?f_y .

} => {
    ?f_d time:year ?f_y .
} .
```

The rules for inferring a maximum temporal bound on the year of death of Nonnosus, given the year of the burial of Nonnosus, are:

```ttl
# If a dated interval is inside (bounded by) another interval (the
# bounding interval), and the dated interval must have occurred before
# another interval, the bounding interval also must have occurred
# before that other interval.
{
    ?i1
      time:before ?i2 ;
      time:intervalIn ?i1_bounds .

} => {
    ?i1_bounds time:before ?i2 .
} .

# If a dated interval occurred before another dated interval, and the
# month of the earlier interval is greater than the month of the later
# interval, then year of the earlier interval is at most one less than
# the year of the later interval.
{
    ?i1 time:before ?i2 .

    ?i1 time:hasEnd [
      time:inDateTime ?i1_e_d
    ] .

    ?i1_e_d time:month ?i1_e_month .

    ?i2 time:hasDateTimeDescription [
      time:month ?i2_month ;
      time:year ?i2_year
    ] .

    ?i1_e_month math:greaterThan ?i2_month .

    ( ?i2_year 1 ) math:difference ?i1_e_year .

} => {
    ?i1_e_d time:year ?i1_e_year .
} .
```

The rule for inferring a maximum temporal bound on the date of the birth of Nonnosus, given the duration of his life and the date of his death, is:

```ttl
# If an interval has a known duration in years, and the maximum
# temporal bound on the finish of the interval is dated, the a date for
# the maximum temporal bound of the start of the interval can be
# inferred.
{
    ?i
      time:intervalStartedBy ?s ;
      time:intervalFinishedBy ?f ;
      time:hasDurationDescription [
        time:years ?years
      ] .

    ?s time:intervalIn ?s_bounds .
    ?f time:intervalIn ?f_bounds .

    ?f_bounds time:hasEnd ?f_e .
    ?s_bounds time:hasEnd ?s_e .

    ?f_e time:inDateTime  [
      time:day ?f_e_d ;
      time:month ?f_e_m ;
      time:year ?f_e_y
    ] .

    ( ?f_e_y ?years ) math:difference ?s_e_y .

} => {
    ?s_e time:inDateTime [
      time:day ?f_e_d ;
      time:month ?f_e_m ;
      time:year ?s_e_y
    ] .
} .
```

See [the full set of inference rules](rules.n3).

After running the model and the inference rules through [the EYE reasoner](https://josd.github.io/eye/), we get the following results:

![Inferred temporal boundaries on the possible dates of the birth and death of Nonnosus](inferred.png)

See [the inferred model in Turtle syntax](inferred.ttl).

