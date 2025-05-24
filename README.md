## Unity Ray Marching
이 프로젝트는 Unity에서 Ray Marching 기법을 이용해 두 개의 SDF(Signed Distance Function) Sphere를 시각화하고, 이를 soft union 연산으로 부드럽게 합치는 데모입니다.

### 📷 실행 영상
![Demo](./demo/raymarching.gif)


### 📌 주요 기능
1. Ray Marching을 이용한 거리장 기반 렌더링
2. 두 개의 구(Sphere)를 soft union으로 부드럽게 결합
3. SDF 기반 렌더링

### 🎮 실행 방법
Unity에서 새 프로젝트 생성
이 RM_Sphere.cs 스크립트를 기본 object에 붙여넣기
Unlit/RayMarch 쉐이더를 머티리얼에 적용 후 해당 오브젝트에 할당
실행 시 두 개의 Sphere가 서로 원운동하며 부드럽게 합쳐지는 효과 확인
  
