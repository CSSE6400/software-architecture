import http from "k6/http";
import { check, sleep } from "k6";

const ENDPOINT = __ENV.ENDPOINT;

export function studyingStudent() {
    let url = ENDPOINT + '/api/v1/todos';

    // What tasks do I have left to work on?
    let request = http.get(url);

    check(request, {
        'is status 200': (r) => r.status === 200,
    });
    
    // Alright I'll go work on my next task for around 2 minutes
    sleep(120);
}

export function indecisivePlanner() {
    let url = ENDPOINT + '/api/v1/todos';

    // I need to work on the CSSE6400 Cloud Assignment!
    const payload = JSON.stringify({
        "title": "CSSE6400 Clout Assignment",
        "completed": false,
        "description": "",
        "deadline_at": "2025-09-05T15:00:00",
    });

    const params = {
        headers: {
            'Content-Type': 'application/json',
        },
    };

    let request = http.post(url, payload, params);
    check(request, {
        'is status 200': (r) => r.status === 200,
    });

    sleep(10);

    // Oh no! Not the Clout assignment, the Cloud assignment!
    const wrongId = request.id;

    request = http.del('${url}/${wrongId}');

    check(request, {
        'is status 200': (r) => r.status === 200,
    });

    // I'll come back to it later :(
    sleep(10);
}

export const options = {
    scenarios: {
        studier: {
            exec: 'studyingStudent',
            executor: "ramping-vus",
            stages: [
                { duration: "1m", target: 1500 },
                { duration: "3m", target: 7500 },
                { duration: "2m", target: 0 },
            ],
        },
        planner: {
            exec: 'indecisivePlanner',
            executor: "shared-iterations",
            vus: 20,
            iterations: 200,
        },
    },
};