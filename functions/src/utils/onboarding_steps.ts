import {AreaCodes} from "./area_codes";

export type OnboardingStep = {
  type: string;
  name: string;
  areaCodes?: AreaCodes[];
};

export const ONBOARDING_STEPS: OnboardingStep[] = [
  {type: "step1", name: "Step 1", areaCodes: ["+1"]},
  // {type: "step2", name: "Step 2", areaCodes: ["+1"]},
  // {type: "step3", name: "Step 3", areaCodes: ["+1"]},
  // {type: "step4", name: "Step 4", areaCodes: ["+1"]},
];
