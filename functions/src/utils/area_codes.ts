export type AreaCodes = "+1" | "+237";

export const AREA_CODES: AreaCodes[] = ["+1", "+237"];

export const getAreaCode = (phoneNumber?: string): AreaCodes => {
  return AREA_CODES.find((areaCode) => {
    return phoneNumber?.startsWith(areaCode);
  }) as AreaCodes;
};
