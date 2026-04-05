import http from 'k6/http';
import { sleep, check } from 'k6';
import { Counter } from 'k6/metrics';

export const requests = new Counter('http_reqs');

export const options = {
  stages: [
    { target: 1000, duration: '1m' },
    { target: 5000, duration: '10m' },
  ],
  thresholds: {
    http_reqs: ['count < 100'],
  },
};

export default function () {
  const res = http.get('http://taskoverflow-1320608222.us-east-1.elb.amazonaws.com/api/v1/todos');

  sleep(1);

  const checkRes = check(res, {
    'status is 200': (r) => r.status === 200
  });
}
