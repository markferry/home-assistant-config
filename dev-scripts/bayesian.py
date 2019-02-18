import sys
import itertools
import yaml

SELF_PRIOR = 0.66
THRESHOLD = 0.90

YAMLS = [
    "config/people/aneta.yaml"
    "config/people/anne.yaml"
    "config/people/jerome.yaml"
    "config/people/liane.yaml"
    "config/people/mark.yaml"
    "config/people/ros.yaml"
    "config/people/thomas.yaml"
]

OBS = {}

def update_probability(prior, prob_true, prob_false):
    """Update probability using Bayes' rule."""
    numerator = prob_true * prior
    denominator = numerator + prob_false * (1 - prior)

    probability = numerator / denominator
    return probability


def load_obs(yamls=YAMLS):
    for y in yamls:
        with open(y, "r") as f:
            obslist = yaml.load(f)["binary_sensor"][0]["observations"]
            OBS[y] = [(o["prob_given_true"], o["prob_given_false"], o["entity_id"]) for o in obslist]


def all_combinations(any_list):
    return itertools.chain.from_iterable(
        itertools.combinations(any_list, i + 1)
        for i in range(len(any_list)))

def calc(c):
    probability = 0.0
    prior = SELF_PRIOR
    s = []
    for obs in c:
        prior = update_probability(
            prior, obs[0], obs[1])
        probability = prior
        s.append(obs[2])

    return (s, probability)

def main():
    load_obs(sys.argv[1:])
    for y, v in OBS.items():
        for c in all_combinations(v):
            res = calc(c)
            if res[1] < THRESHOLD:
                print(calc(c))


if __name__ == "__main__":
    main()
