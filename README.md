# Reasoning about relative times of events in the life of Nonnsus

In the altar of the parish church in Molzbichl there is a tombstone with the only inscription in Austria from the 6th century. The Latin inscription [reads](https://de.wikipedia.org/wiki/Nonnosus)

> Here rests the servant of Christ, the deacon Nonnosus, who lived about 103 years. He died on September 2nd and was buried on July 20th at this place in the eleventh year of the indiction three years after the consulship of the most famous men Lampadius and Orestes.

The assertions made in this inscription can be modeled using the [OWL-Time ontology](https://www.w3.org/TR/owl-time/):

![OWL-Time model of assertions made in the inscription on the tombstone of Nonnosus](nonnosus.png)

See [this model in Turtle syntax](nonnosus.ttl).

From this model we can infer temporal boundaries on the possible dates of the birth and death of Nonnosus. To do this we need some inference rules. The rules used here are written in [Notation3](https://n3.restdesc.org/n3/), a superset of Turtle that also allows inference rules to be expressed.

The rule for inferring the year of the burial of Nonnosus from the year of the consulate of Lampadius and Orestes is:

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

See [the full set of inference rules](rules.n3).

After running the model and the inference rules through [the EYE reasoner](https://josd.github.io/eye/), we get the following results:

![Inferred temporal boundaries on the possible dates of the birth and death of Nonnosus](inferred.png)

See [the inferred model in Turtle syntax](inferred.ttl).

