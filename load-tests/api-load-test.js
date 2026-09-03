import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 10,          // 10 "virtual user"
  duration: '30s',  // running in 30s
  thresholds: {
    http_req_duration: ['p(95)<500'],  // 95% request phải nhanh hơn 500ms
    http_req_failed: ['rate<0.01'],    // tỷ lệ lỗi phải dưới 1%
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