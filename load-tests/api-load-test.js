import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '10s', target: 20 },  // increase to 20 VU in 10s
    { duration: '20s', target: 20 },  // 20 VU in 20s
    { duration: '10s', target: 0 },   // down to 0
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'],  
    http_req_failed: ['rate<0.01'],    
  }
};

export default function () {
  const res = http.get('https://jsonplaceholder.typicode.com/posts/1');

  check(res, {
    'status is 200': (r) => r.status === 200,
    'response time < 500ms': (r) => r.timings.duration < 500,
  });

  sleep(1); 
}