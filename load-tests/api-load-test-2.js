import http from 'k6/http';
import { check, sleep, group } from 'k6';

export const options = {
  vus: 15,
  duration: '20s',
  thresholds: {
    http_req_duration: ['p(95)<500'],
    http_req_failed: ['rate<0.01'],
  },
};

export default function () {
  group('Get posts', () => {
    const res = http.get('https://jsonplaceholder.typicode.com/posts');
    check(res, { 'status 200': (r) => r.status === 200 });
  });

  group('Get post detail', () => {
    const res = http.get('https://jsonplaceholder.typicode.com/posts/1');
    check(res, { 'status 200': (r) => r.status === 200 });
  });

  sleep(1);
}