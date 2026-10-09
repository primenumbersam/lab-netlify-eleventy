#import "/typst/templates/textbook.typ": *

#show: project.with(
  title: "디지털 이미지와 3차원 텐서 행렬 변환 연산",
  subtitle: "픽셀 좌표 변환과 아핀 변환의 대수적 증명",
  unit: "제 04 장 심화 각론",
  author: "gitsam",
  date: "2026-09-06",
)

= 1. 서론 (Introduction)

웹 총론에서 다룬 시각 자료의 기본 단위(픽셀)와 행렬 구조를 기초로 하여, 본 각론에서는 컴퓨터 비전에서 활용되는 2차원 및 3차원 이미지 좌표 변환의 기하학적·대수적 원리를 엄밀하게 전개한다.

#definition(title: "정의: RGB 이미지의 다층 행렬(텐서) 표현")[
  가로 $W$, 세로 $H$ 크기의 24-bit 컬러 이미지는 3계 텐서(3rd-order tensor) $bold(I) in bb(R)^(H times W times 3)$로 정의된다. 각 채널 $c in {0, 1, 2}$는 각각 Red, Green, Blue 채널의 이산 강도값(intensity)을 나타낸다.
]

= 2. 이미지의 선형 결합과 볼록 결합 (Convex Combination)

두 이미지 $bold(A), bold(B) in bb(R)^(H times W)$에 대하여 파라미터 $alpha in [0, 1]$를 이용한 선형 보간은 다음과 같이 계산된다:

$ bold(C) = alpha bold(A) + (1 - alpha) bold(B) $

이 연산은 명도 공간(color space) 내에서 두 점을 잇는 선분 상의 점을 생성하므로, 알파 블렌딩(Alpha Blending)의 수학적 기초가 된다.

#theorem(title: "명도 보존 정리")[
  임의의 $alpha in [0, 1]$에 대해, 입력 이미지들의 모든 원소가 $[0, 255]$ 범위에 존재한다면 합성 이미지 $bold(C)$의 모든 원소 역시 오버플로우 없이 $[0, 255]$ 범위 내에 보존된다.
]

= 3. 아핀 변환 (Affine Transformation)

2차원 픽셀 좌표 $(x, y)$를 동차 좌표계(Homogeneous Coordinates) $(x, y, 1)^T$로 확장함으로써, 회전(Rotation), 크기 조절(Scaling), 평행 이동(Translation)을 단일 3x3 행렬의 곱으로 표현할 수 있다.

$ mat(x'; y'; 1) = mat(a, b, t_x; c, d, t_y; 0, 0, 1) mat(x; y; 1) $

#note(title: "계산 최적화 주의점")[
  역방향 매핑(Inverse Mapping)과 쌍선형 보간법(Bilinear Interpolation)을 적용하지 않고 정방향 매핑을 수행할 경우 빈 픽셀(Hole) 현상이 발생하므로 역변환 행렬 $bold(M)^(-1)$을 구하여 샘플링해야 한다.
]
